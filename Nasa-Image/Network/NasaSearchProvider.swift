//
//  NasaSearchProvider.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import Foundation
import UIKit

protocol NasaSearchProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem]
}

enum NetworkError: Error {
    case InvalidURL
}

struct NasaSearchProvider: NasaSearchProviding {
    private let url = URL(string: "https://images-api.nasa.gov/search")
    
    func nasaImageSearch(searchFor query: String) async throws -> [NasaItem] {
        guard let url = url?.appending(queryItems: [URLQueryItem(name: "q", value: query), URLQueryItem(name: "media_type", value: "image")]) else {
            throw NetworkError.InvalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let nasaItems = try JSONDecoder().decode(NasaResult.self, from: data).collection.items
        
        return nasaItems
    }
}
