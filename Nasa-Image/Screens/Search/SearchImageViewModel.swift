//
//  SearchImageViewModel.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import Foundation
import UIKit
import Cache

class SearchImageViewModel: ObservableObject {
    @Published var nasaListItems: [NasaListItem] = []
    @Published var loadingState: LoadingState = .initial
    @Published var isError: Bool = false
    @Published var noResultAlert: Bool = false
    var searchQuery = ""
    private var task: Task<Void, Never>?
    
    enum LoadingState: Equatable {
        case initial
        case loading
        case loaded
    }
    
    private let nasaDataProvider: NasaDataProviding
    private let cacheImageDataStore: CacheImageStoring & CacheImageProviding
    private let imageProviding: ImageProviding
    
    init(nasaDataProvider: NasaDataProviding = NasaDataProvider(), cacheImageDataStore: CacheImageStoring & CacheImageProviding = CachedImageDataStore(), imageProvider: ImageProviding = ImageProvider()) {
        self.nasaDataProvider = nasaDataProvider
        self.cacheImageDataStore = cacheImageDataStore
        self.imageProviding = imageProvider
    }
    
    func clearResults() {
        task?.cancel()
        loadingState = .initial
        nasaListItems = []
    }
    
    func searchNasaImages() async {
        await MainActor.run {
            loadingState = .loading
        }
        
        let nasaItems = await fetchNasaItems()
        guard !nasaItems.isEmpty else { return }
        
        task = Task {
            do {
                try Task.checkCancellation()
                
                print("Clear Before--- \(nasaListItems)")
                await MainActor.run {
                    nasaListItems = []
                    loadingState = .loaded
                }
                print("Clear After--- \(nasaListItems)")
                
                try await preloadPlaceholderImages(items: nasaItems)
                
                for (i, item) in nasaItems.enumerated() {
                    try Task.checkCancellation()
                    try await addToNasaListItems(idx: i, item: item)
                }
                
            } catch {
                if error is CancellationError {
                    print("Cancelled Task")
                } else {
                    print(error)
                    await MainActor.run {
                        self.isError = true
                        if nasaListItems.isEmpty {
                            loadingState = .initial
                        } else {
                            loadingState = .loaded
                        }
                    }
                }
            }
        }
        await task?.value
    }
    
    @MainActor
    private func fetchNasaItems() async -> [NasaItem] {
        do {
            let nasaItems = try await nasaDataProvider.nasaSearch(searchFor: searchQuery)
            if nasaItems.isEmpty {
                self.noResultAlert = true
                if !nasaListItems.isEmpty {
                    loadingState = .loaded
                } else {
                    loadingState = .initial
                }
                return nasaItems
            }
            /// Cancel the previous search task, if we requested a valid search.
            task?.cancel()
            return nasaItems
        } catch let error {
            if error is CancellationError {
                print("Cancelled Task")
            } else {
                print(error)
                self.isError = true
                if nasaListItems.isEmpty {
                    loadingState = .initial
                } else {
                    loadingState = .loaded
                }
            }
        }
        return []
    }
    
    @MainActor
    private func addToNasaListItems(idx: Int, item: NasaItem) async throws {
        let listItem = await buildNasaListItem(item: item)
        try Task.checkCancellation()
        nasaListItems[idx] = listItem
    }
    
    private func preloadPlaceholderImages(items: [NasaItem]) async throws {
        for i in 0..<items.count {
            var image: UIImage?
            if let imageLink = items[i].links.first?.imageLink, let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                do {
                    image = try cacheImageDataStore.image(for: url)
                } catch {}
            }
            let listItem = NasaListItem(title: items[i].data.first?.title ?? "", image: image, description: "", dateCreated: "", nasaItem: items[i])
            try Task.checkCancellation()
            await MainActor.run {
                nasaListItems.append(listItem)
            }
        }
    }
    
    private func buildNasaListItem(item: NasaItem) async -> NasaListItem {
        var finalDate = ""
        var description: AttributedString = ""
        var image: UIImage?
        
        if let imageLink = item.links.first?.imageLink, let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            do {
                let uiImage = try await imageProviding.getImage(for: url)
                image = uiImage
                cacheImageDataStore.store(image: uiImage, for: url)
            } catch {
                print(error)
            }
        }
        
        let dateFormatter = ISO8601DateFormatter()
        if let nasaData = item.data.first, let date = dateFormatter.date(from: nasaData.date_created) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            finalDate = formatter.string(from: date)
            do {
                description = try nasaData.description?.htmlToAttributedString() ?? ""
            } catch {
                description = ""
            }
        }
        
        return NasaListItem(title: item.data.first?.title ?? "", image: image, description: description, dateCreated: finalDate, nasaItem: item)
    }
}
