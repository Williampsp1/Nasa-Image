//
//  CachedImageDataStore.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import Cache
import UIKit

struct CachedImageDataStore: CacheImageProviding, CacheImageStoring {
    func image(for url: URL) throws -> UIImage {
        return try Global.images.resolve(url)
    }

    func store(image: UIImage, for url: URL) {
        Global.images.set(value: image, forKey: url)
    }
}


