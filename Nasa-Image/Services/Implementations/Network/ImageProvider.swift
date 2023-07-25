//
//  ImageProvider.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

struct ImageProvider: ImageProviding {
    func getImage(for url: URL) async throws -> UIImage {
        let data = try Data(contentsOf: url)
        guard let uiImage = UIImage(data: data) else {
            print("Error decoding image from data")
            throw NetworkError.imageDecoding
        }
        return uiImage
    }
}
