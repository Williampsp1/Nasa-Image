//
//  MockImageProvider.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

struct MockImageProvider: ImageProviding {
    func getImage(for url: URL) async throws -> UIImage {
        return UIImage(systemName: "star")!
    }
}

struct MockImageDecodingError: ImageProviding {
    func getImage(for url: URL) async throws -> UIImage {
        throw NetworkError.imageDecoding
    }
}
