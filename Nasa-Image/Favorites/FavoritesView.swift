//
//  FavoritesVIew.swift
//  Nasa-Image
//
//  Created by William on 7/1/23.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoriteService: FavoritesService
    
    var body: some View {
        VStack {
            Text("Favorites")
                .font(.system(.title, design: .monospaced, weight: .medium))
                .multilineTextAlignment(.center)
                .shadow(color: .gray, radius: 3, x: 0, y: 2)
            
            if favoriteService.favorites.isEmpty {
                Text("Add some favorites.")
                    .padding(.top, 50)
            }
            
            ListingView(items: favoriteService.favorites)
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesService())
    }
}
