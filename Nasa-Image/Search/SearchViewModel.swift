//
//  ListViewModel.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import Foundation
import UIKit

class SearchViewModel: ObservableObject {
    @Published var nasaListItems: [NasaListItem] = []
    @Published var loadingState: LoadingState = .Initial
    var searchQuery = ""
    private var task: Task<Void, Never>? = nil
    
    enum LoadingState {
        case Initial
        case Loading
        case Listing
        case Error
        case NoResult(query: String)
    }
    
    private let nasaSearchProvider: NasaSearchProviding
    
    init(nasaSearchProvider: NasaSearchProviding = NasaSearchProvider()) {
        self.nasaSearchProvider = nasaSearchProvider
    }
    
    func clearResults() {
        task?.cancel()
        searchQuery = ""
        loadingState = .Initial
        nasaListItems = []
    }
    
    func searchNasaImages() async {
        task?.cancel()
        let searchedQuery = searchQuery
        await MainActor.run {
            nasaListItems = []
            searchQuery = ""
            loadingState = .Loading
        }
        task = Task {
            do {
                let nasaItems = try await nasaSearchProvider.nasaImageSearch(searchFor: searchedQuery)
                await MainActor.run {
                    loadingState = .Listing
                }
                
                for item in nasaItems {
                    try Task.checkCancellation()
                    print("\(item)")
                    if let listItem = await buildNasaListItem(item: item) {
                        await MainActor.run {
                            nasaListItems.append(listItem)
                        }
                    }
                }
                
                if nasaItems.isEmpty {
                    await MainActor.run {
                        loadingState = .NoResult(query: searchedQuery)
                    }
                }
            } catch is CancellationError {
                print("Cancelled Task clear--- \(nasaListItems)")
                await MainActor.run {
                    nasaListItems = []
                }
                print("After cancellation clear--- \(nasaListItems)")
            } catch let error {
                print(error)
                print(error.localizedDescription)
                await MainActor.run {
                    loadingState = .Error
                }
            }
        }
    }
    
    private func buildNasaListItem(item: NasaItem) async -> NasaListItem? {
        var image = UIImage()
        var listItem: NasaListItem?
        
        if let title = item.data.first?.title, let imageLink = item.links.first?.imageLink {
            if let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                let imageData = try? Data(contentsOf: url)
                if let imageData = imageData {
                    image = UIImage(data: imageData) ?? UIImage()
                }
            }
            
            listItem = NasaListItem(title: title, image: image)
        }
        return listItem
    }
}
