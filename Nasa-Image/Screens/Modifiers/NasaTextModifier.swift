//
//  NasaTextModifier.swift
//  Nasa-Image
//
//  Created by William on 6/23/23.
//

import SwiftUI

struct NasaTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .monospaced, weight: .light))
            .multilineTextAlignment(.center)
    }
}

extension Text {
    func nasaText() -> some View {
        self.modifier(NasaTextModifier())
    }
}
