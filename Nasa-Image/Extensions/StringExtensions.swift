//
//  StringExtensions.swift
//  Nasa-Image
//
//  Created by William on 6/23/23.
//

import Foundation
import UIKit

extension String {
    func htmlToAttributedString() throws -> AttributedString {
        try .init(
            .init(
                data: .init(utf8),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        )
        .mergingAttributes(AttributeContainer([.font: UIFont.systemFont(ofSize: 15)]))
    }
}
