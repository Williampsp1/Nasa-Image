//
//  NasaImageProvider.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import Foundation
import UIKit

protocol NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem]
}

struct NasaImageProvider: NasaImageProviding {
    private let url = URL(string: "https://images-api.nasa.gov/search")
    
    func nasaImageSearch(searchFor query: String) async throws -> [NasaItem] {
        guard let url = url?.appending(queryItems: [URLQueryItem(name: "q", value: query), URLQueryItem(name: "media_type", value: "image")]) else {
            throw NetworkError.InvalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        try Task.checkCancellation()
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkError.HTTPError
        }
        
        let nasaItems = try JSONDecoder().decode(NasaResult.self, from: data).collection.items
        
        return nasaItems
    }
}
