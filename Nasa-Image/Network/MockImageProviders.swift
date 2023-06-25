//
//  MockImageProviders.swift
//  Nasa-Image
//
//  Created by William on 6/22/23.
//

import Foundation

struct MockNasaImageProvider: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        return MockResult.nasaItems
    }
}

struct MockNasaImageProviderEmpty: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        return MockResult.emptyNasaItems
    }
}

struct MockNasaImageInvalidURL: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.InvalidURL
    }
}

struct MockNasaImageHTTPError: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.HTTPError
    }
}

struct MockNasaImageDecodingError: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.DecodingError
    }
}

struct MockNasaImageCancelled: NasaImageProviding {
    func nasaImageSearch(searchFor search: String) async throws -> [NasaItem] {
        throw CancellationError()
    }
}
