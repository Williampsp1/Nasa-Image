//
//  ListItemView.swift
//  Nasa-Image
//
//  Created by Rafaela on 6/21/23.
//

import SwiftUI

struct ImageItemView: View {
    var item: NasaListItem
    
    var body: some View {
        VStack {
            Text(item.title)
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImageItemView(item: NasaListItem(title: "Mars on here ", image: UIImage(systemName: "star")!))
    }
}
