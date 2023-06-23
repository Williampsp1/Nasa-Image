//
//  NetworkError.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/23/23.
//

import Foundation

enum NetworkError: Error {
    case InvalidURL
    case HTTPError
    case DecodingError
}
