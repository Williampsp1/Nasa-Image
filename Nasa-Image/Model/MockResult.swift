//
//  MockResult.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/22/23.
//

import Foundation
import UIKit

enum MockResult {
    static private let data = NasaData(date_created: "1969-06-03", description: "A really big moon", title: "The big moon")
    static private let link = ImageLink(imageLink: "https://images-assets.nasa.gov/image/APOLLO 50th_FULL COLOR_300DPI/APOLLO 50th_FULL COLOR_300DPI~thumb.jpg")
    static let nasaItems: [NasaItem] = [NasaItem(data: [data], links: [link])]
    static let nasaListItem = NasaListItem(title: data.title, image: UIImage(systemName: "star") ?? UIImage(), description: "A big moon", dateCreated: "2019-05-12")
    static let emptyNasaItems: [NasaItem] = []
}
