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
                .shadow(color: .gray, radius: 1, x: 0, y: 2)
            
            Spacer()
            if favoriteService.favorites.isEmpty {
                VStack {
                    Text("Add some favorites.")
                        .padding(.top, 50)
                    Image("nasa")
                        .resizable()
                        .scaledToFit()
                }
            } else {
                ListingView(items: favoriteService.favorites)
            }
            Spacer()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(FavoritesService())
    }
}
