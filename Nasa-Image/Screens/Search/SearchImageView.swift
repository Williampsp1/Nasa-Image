//
//  SearchImageView.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import SwiftUI

struct SearchImageView: View {
    @StateObject private var viewModel = SearchImageViewModel()
    @StateObject private var favoritesService = FavoritesService()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.loadingState {
                case .initial:
                    VStack {
                        Text("What do you want to find in the stars?")
                            .nasaText()
                        Image("nasa")
                            .resizable()
                            .scaledToFit()
                    }
                case .loading: ProgressView()
                case .loaded: listingView
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: FavoritesView(), label: {
                        Text("Favorites")
                            .nasaText()
                    })
                }
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search for NASA Images")
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .alert("Error occured, please try again.", isPresented: $viewModel.isError) {}
            .alert("No results for \(viewModel.searchQuery)", isPresented: $viewModel.noResultAlert) {}
            .navigationBarTitleDisplayMode(.inline)
        }
        .onSubmit(of: .search) {
            Task { await viewModel.searchNasaImages() }
        }
        .environmentObject(favoritesService)
    }
    
    var listingView: some View {
        VStack {
            Button(action: {
                viewModel.clearResults()
            }) {
                Text("Clear Results")
            }
            .buttonStyle(.borderedProminent)
            ListingView(items: viewModel.nasaListItems)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchImageView()
    }
}
