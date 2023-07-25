//
//  ImageDetailView.swift
//  Nasa-Image
//
//  Created by William on 6/23/23.
//

import SwiftUI

struct ImageDetailView: View {
    @EnvironmentObject private var favoriteService: FavoritesService
    let item: NasaListItem
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item.title)
                    .font(.system(.title, design: .monospaced, weight: .medium))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                Spacer()
                if let image = item.image {
                    Image(uiImage: image)
                        .nasaImage()
                        .padding(15)
                    Text("Date: \(item.dateCreated)")
                        .font(.caption)
                        .fontDesign(.monospaced)
                } else {
                    ProgressView()
                }
                Spacer()
            }
            .frame(height: 400)
            .padding(.bottom, 10)
            
            VStack(spacing: 10) {
                Text("Description")
                    .nasaText()
                    .underline()
                
                if !item.description.description.isEmpty {
                    Text(item.description)
                        .padding(8)
                        .background(.gray.opacity(0.8))
                        .cornerRadius(12)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    favoriteService.addFavorite(item: item)
                }) {
                    HStack {
                        Text(favoriteService.contains(item: item) ? "Unfavorite" : "Favorite")
                            .nasaText()
                        Image(systemName: favoriteService.contains(item: item) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                .opacity(item.image == nil && item.description.description.isEmpty ? 0.4 : 1)
                .disabled(item.image == nil && item.description.description.isEmpty)
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
