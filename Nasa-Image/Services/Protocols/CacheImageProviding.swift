//
//  ImageProviding.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

protocol CacheImageProviding {
    func image(for url: URL) throws -> UIImage
}
