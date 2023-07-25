//
//  NasaListItem.swift
//  Nasa-Image
//
//  Created by William on 7/24/23.
//

import Foundation
import UIKit

struct NasaListItem: Equatable, Identifiable {
    let title: String
    var image: UIImage?
    var description: AttributedString
    var dateCreated: String
    let nasaItem: NasaItem
    var id: NasaItem {
        return nasaItem
    }
}
