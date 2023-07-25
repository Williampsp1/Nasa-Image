//
//  FavoritesService.swift
//  Nasa-Image
//
//  Created by William on 7/1/23.
//

import Foundation

class FavoritesService: ObservableObject {
    @Published var favorites: [NasaListItem] = []
    
    func addFavorite(item: NasaListItem) {
        if let index = favorites.firstIndex(of: item) {
            favorites.remove(at: index)
        } else {
            favorites.append(item)
        }
    }
    
    func contains(item: NasaListItem) -> Bool {
        favorites.contains(item)
    }
}
