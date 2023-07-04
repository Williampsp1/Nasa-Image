//
//  NasaListingView.swift
//  Nasa-Image
//
//  Created by William on 7/1/23.
//

import SwiftUI

struct ListingView: View {
    var items: [NasaListItem]
    
    var body: some View {
        List {
            ForEach(items) { item in
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

struct NasaListingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListingView(items: [MockResult.nasaListItem])
        }.environmentObject(FavoritesService())
    }
}
