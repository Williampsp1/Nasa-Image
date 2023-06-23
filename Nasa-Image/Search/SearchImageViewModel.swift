//
//  SearchImageViewModel.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import Foundation
import UIKit

class SearchImageViewModel: ObservableObject {
    @Published var nasaListItems: [NasaListItem] = []
    @Published var loadingState: LoadingState = .initial
    @Published var isError: Bool = false
    var searchQuery = ""
    private var task: Task<Void, Never>?
    
    enum LoadingState: Equatable {
        case initial
        case loading
        case loaded
        case noResult(query: String)
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
        task?.cancel()
        await MainActor.run {
            loadingState = .loading
        }
        task = Task {
            do {
                let nasaItems = try await nasaImageProvider.nasaImageSearch(searchFor: searchQuery)
                try Task.checkCancellation()
                await MainActor.run {
                    nasaListItems = []
                    loadingState = .loaded
                }
                for item in nasaItems {
                    try Task.checkCancellation()
                    print("\(item)")
                    if let listItem = buildNasaListItem(item: item) {
                        await MainActor.run {
                            nasaListItems.append(listItem)
                        }
                    }
                }
                
                if nasaItems.isEmpty {
                    await MainActor.run {
                        loadingState = .noResult(query: searchQuery)
                    }
                }
            } catch let error {
                print(error)
                if error is CancellationError {
                    print("Cancelled Task clear--- \(nasaListItems)")
                    await MainActor.run {
                        nasaListItems = []
                    }
                    print("After cancellation clear--- \(nasaListItems)")
                } else {
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
    
    private func buildNasaListItem(item: NasaItem) -> NasaListItem? {
        var image = UIImage()
        var listItem: NasaListItem?
        
        guard let nasaData = item.data.first, let imageLink = item.links.first?.imageLink, let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""), let imageData = try? Data(contentsOf: url) else {
            return nil
        }
        
        image = UIImage(data: imageData) ?? UIImage()
        listItem = NasaListItem(title: nasaData.title, image: image, description: nasaData.description ?? "" , dateCreated: nasaData.date_created)
        
        return listItem
    }
}
