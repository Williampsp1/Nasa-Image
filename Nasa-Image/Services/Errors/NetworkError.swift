//
//  NetworkError.swift
//  Nasa-Image
//
//  Created by William on 6/23/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case httpError
    case decodingError
    case imageDecoding
}
