//
//  NasaResult.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import Foundation
import UIKit

struct NasaResult: Codable {
    let collection: NasaCollection
}

struct NasaCollection: Codable {
    let items: [NasaItem]
}

struct NasaItem: Codable, Hashable {
    let data: [NasaData]
    let links: [ImageLink]
}

struct ImageLink: Codable, Hashable {
    let imageLink: String
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "href"
    }
}

struct NasaData: Codable, Hashable {
    let date_created: String
    let description: String?
    let title: String
}
