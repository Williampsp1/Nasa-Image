//
//  SearchView.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.loadingState {
                case .Error: Text("Error fetching images")
                case .Initial: Text("What do you want to find in the stars?")
                case .Loading: ProgressView()
                case .NoResult(let query): Text("No results found for \(query)")
                case .Listing:
                    VStack {
                        Button(action: {
                            viewModel.clearResults()
                        }) {
                            Text("Clear Results")
                        }
                        .buttonStyle(.borderedProminent)
                        List {
                            ForEach(viewModel.nasaListItems) { item in
                                ImageItemView(item: item)
                                Divider()
                                    .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $viewModel.searchQuery, prompt: "Search for NASA Images")
        .onSubmit(of: .search) {
            Task { await viewModel.searchNasaImages() }
        }
        
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
