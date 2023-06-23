//
//  ImageDetailView.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/23/23.
//

import SwiftUI

struct ImageDetailView: View {
    let item: NasaListItem
    
    var body: some View {
        ScrollView {
            VStack {
                Text(item.title)
                    .font(.system(.title, design: .monospaced, weight: .medium))
                    .multilineTextAlignment(.center)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                Image(uiImage: item.image)
                    .nasaImage()
                    .padding(15)
                
                Text("Date created: \(item.dateCreated)")
                    .font(.caption)
                    .fontDesign(.monospaced)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 10) {
                Text("Description")
                    .nasaText()
                    .underline()
                
                Text(item.description)
                    .font(.footnote)
                    .padding(8)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(12)
            }
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(item: MockResult.nasaListItem)
    }
}
