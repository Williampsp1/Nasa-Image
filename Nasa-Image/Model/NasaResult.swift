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

struct NasaItem: Codable {
    let data: [NasaData]
    let links: [ImageLink]
}

struct ImageLink: Codable {
    let imageLink: String
    
    enum CodingKeys: String, CodingKey {
        case imageLink = "href"
    }
}

struct NasaData: Codable {
    let date_created: String
    let description: String?
    let title: String
}

struct NasaListItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let image: UIImage?
    let description: AttributedString
    let dateCreated: String
}
