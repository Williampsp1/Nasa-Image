//
//  ImageProviding.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

protocol ImageProviding {
    func getImage(for url: URL) async throws -> UIImage
}
