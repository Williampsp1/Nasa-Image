//
//  NasaImageProviding.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation

protocol NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem]
}
