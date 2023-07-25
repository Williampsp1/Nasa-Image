//
//  MockImageProviders.swift
//  Nasa-Image
//
//  Created by William on 6/22/23.
//

import Foundation

struct MockNasaDataProvider: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        return MockResult.nasaItems
    }
}

struct MockNasaDataProviderEmpty: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        return MockResult.emptyNasaItems
    }
}

struct MockNasaDataInvalidURL: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.invalidURL
    }
}

struct MockNasaDataHTTPError: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.httpError
    }
}

struct MockNasaDataDecodingError: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        throw NetworkError.decodingError
    }
}

struct MockNasaDataCancelled: NasaDataProviding {
    func nasaSearch(searchFor search: String) async throws -> [NasaItem] {
        throw CancellationError()
    }
}
