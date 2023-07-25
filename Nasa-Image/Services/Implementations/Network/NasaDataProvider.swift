//
//  NasaImageProvider.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import Foundation
import UIKit

struct NasaDataProvider: NasaDataProviding {
    private let url = URL(string: "https://images-api.nasa.gov/search")
    
    func nasaSearch(searchFor query: String) async throws -> [NasaItem] {
        guard let url = url?.appending(queryItems: [URLQueryItem(name: "q", value: query), URLQueryItem(name: "media_type", value: "image")]) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            throw NetworkError.httpError
        }
        
        let nasaItems = try JSONDecoder().decode(NasaResult.self, from: data).collection.items
        
        return nasaItems
    }
}
