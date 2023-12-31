//
//  ImageItemView.swift
//  Nasa-Image
//
//  Created by William on 6/21/23.
//

import SwiftUI

struct ImageItemView: View {
    var title: String
    var image: UIImage?
    
    var body: some View {
        VStack {
            Text(title)
                .nasaText()
            Spacer()
            if let image = image {
                Image(uiImage: image)
                    .nasaImage()
                    .padding(.bottom, 15)
            } else {
                ProgressView()
            }
            Spacer()
            Divider()
        }
        .frame(height: 300)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ImageItemView(title: MockResult.nasaListItem.title, image: UIImage(systemName: "star"))
        }
    }
}
