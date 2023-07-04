//
//  SearchImageViewModel.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import Foundation
import UIKit

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
    
    private let nasaImageProvider: NasaImageProviding
    
    init(nasaImageProvider: NasaImageProviding = NasaImageProvider()) {
        self.nasaImageProvider = nasaImageProvider
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
                }
            }
        }
        await task?.value
    }
    
    private func fetchNasaItems() async -> [NasaItem] {
        do {
            let nasaItems = try await nasaImageProvider.nasaImageSearch(searchFor: searchQuery)
            if nasaItems.isEmpty {
                await MainActor.run {
                    self.noResultAlert = true
                    if !nasaListItems.isEmpty {
                        loadingState = .loaded
                    } else {
                        loadingState = .initial
                    }
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
        return []
    }
    
    private func addToNasaListItems(idx: Int, item: NasaItem) async throws {
        if let listItem = buildNasaListItem(item: item) {
            try Task.checkCancellation()
            await MainActor.run {
                nasaListItems[idx] = listItem
            }
        }
    }
    
    private func preloadPlaceholderImages(items: [NasaItem]) async throws {
        for i in 0..<items.count {
            let listItem = NasaListItem(title: items[i].data.first?.title ?? "", image: nil, description: "", dateCreated: "")
            try Task.checkCancellation()
            await MainActor.run {
                nasaListItems.append(listItem)
            }
        }
    }
    
    private func buildNasaListItem(item: NasaItem) -> NasaListItem? {
        var listItem: NasaListItem?
        var finalDate = ""
        var description: AttributedString = ""
        
        guard let nasaData = item.data.first, let imageLink = item.links.first?.imageLink, let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), let imageData = try? Data(contentsOf: url) else {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: nasaData.date_created) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            finalDate = formatter.string(from: date)
        }
        do {
            description = try nasaData.description?.htmlToAttributedString() ?? ""
        } catch {
            description = ""
        }
        
        let image = UIImage(data: imageData) ?? UIImage()
        listItem = NasaListItem(title: nasaData.title, image: image, description: description, dateCreated: finalDate)
        
        return listItem
    }
}
