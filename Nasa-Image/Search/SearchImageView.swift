//
//  SearchImageView.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import SwiftUI

struct SearchImageView: View {
    @StateObject private var viewModel = SearchImageViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.loadingState {
                case .initial: Text("What do you want to find in the stars?")
                        .nasaText()
                case .loading: ProgressView()
                case .noResult(let query): Text("No results found for \(query)")
                        .nasaText()
                case .loaded: listingView
                }
            }
            .alert("Error occured, please try again.", isPresented: $viewModel.isError) {}
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $viewModel.searchQuery, prompt: "Search for NASA Images")
        .onSubmit(of: .search) {
            Task { await viewModel.searchNasaImages() }
        }
    }
    
    var listingView: some View {
        VStack {
            Button(action: {
                viewModel.clearResults()
            }) {
                Text("Clear Results")
            }
            .buttonStyle(.borderedProminent)
            List {
                ForEach(viewModel.nasaListItems) { item in
                    NavigationLink(destination: ImageDetailView(item: item)) {
                        ImageItemView(title: item.title, image: item.image)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchImageView()
    }
}
