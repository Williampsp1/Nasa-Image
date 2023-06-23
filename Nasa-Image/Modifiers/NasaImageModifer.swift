//
//  NasaImageModifer.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/23/23.
//

import SwiftUI

extension Image {
    func nasaImage() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .shadow(color: .gray, radius: 3, x: 0, y: 5)
    }
}
