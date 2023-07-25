//
//  ImageStoring.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

protocol CacheImageStoring {
    func store(image: UIImage, for url: URL)
}
