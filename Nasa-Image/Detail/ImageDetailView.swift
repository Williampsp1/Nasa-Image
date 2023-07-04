//
//  ImageDetailView.swift
//  Nasa-Image
//
//  Created by William on 6/23/23.
//

import SwiftUI

struct ImageDetailView: View {
    let item: NasaListItem
    @EnvironmentObject private var favoriteService: FavoritesService
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item.title)
                    .font(.system(.title, design: .monospaced, weight: .medium))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                
                if let image = item.image {
                    Image(uiImage: image)
                        .nasaImage()
                        .padding(15)
                }
                
                Text("Date: \(item.dateCreated)")
                    .font(.caption)
                    .fontDesign(.monospaced)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 10) {
                Text("Description")
                    .nasaText()
                    .underline()
                
                Text(item.description)
                    .padding(8)
                    .background(.gray.opacity(0.9))
                    .cornerRadius(12)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    favoriteService.addFavorite(item: item)
                }) {
                    Image(systemName: favoriteService.favorites.contains(item) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImageDetailView(item: MockResult.nasaListItem)
        }
        .environmentObject(FavoritesService())
    }
}
