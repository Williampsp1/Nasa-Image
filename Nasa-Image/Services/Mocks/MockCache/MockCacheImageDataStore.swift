//
//  MockCacheImageDataStore.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import Cache
import UIKit

fileprivate class MockCache {
    var cache: [URL: UIImage] = [:]
}

struct MockCachedImageDataStore: CacheImageProviding, CacheImageStoring {
    private var images: MockCache = MockCache()
    func image(for url: URL) throws -> UIImage {
        return try images.cache.resolve(url)
    }

    func store(image: UIImage, for url: URL) {
        images.cache.set(value: image, forKey: url)
    }
}
