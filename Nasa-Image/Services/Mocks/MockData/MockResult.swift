//
//  MockResult.swift
//  Nasa-Image
//
//  Created by William on 6/22/23.
//

import Foundation
import UIKit

enum MockResult {
    static private let data = NasaData(date_created: "1969-06-03", description: "The Sun blew out a coronal mass ejection along with part of a solar filament over a three-hour period (Feb. 24, 2015). While some of the strands fell back into the Sun, a substantial part raced into space in a bright cloud of particles (as observed by the SOHO spacecraft). The activity was captured in a wavelength of extreme ultraviolet light. Because this occurred way over near the edge of the Sun, it was unlikely to have any effect on Earth.   Download high res/video file: <a href=\"http://sdo.gsfc.nasa.gov/gallery/potw/item/603\" rel=\"nofollow\">sdo.gsfc.nasa.gov/gallery/potw/item/603</a>  Credit: NASA/Solar Dynamics Observatory  <b><a href=\"http://www.nasa.gov/audience/formedia/features/MP_Photo_Guidelines.html\" rel=\"nofollow\">NASA image use policy.</a></b>  <b><a href=\"http://www.nasa.gov/centers/goddard/home/index.html\" rel=\"nofollow\">NASA Goddard Space Flight Center</a></b> enables NASA’s mission through four scientific endeavors: Earth Science, Heliophysics, Solar System Exploration, and Astrophysics. Goddard plays a leading role in NASA’s accomplishments by contributing compelling scientific knowledge to advance the Agency’s mission. <b>Follow us on <a href=\"http://twitter.com/NASAGoddardPix\" rel=\"nofollow\">Twitter</a></b> <b>Like us on <a href=\"http://www.facebook.com/pages/Greenbelt-MD/NASA-Goddard/395013845897?ref=tsd\" rel=\"nofollow\">Facebook</a></b> <b>Find us on <a href=\"http://instagram.com/nasagoddard?vm=grid\" rel=\"nofollow\">Instagram</a></b>", title: "The big moon")
    static private let link = ImageLink(imageLink: "https://images-assets.nasa.gov/image/APOLLO 50th_FULL COLOR_300DPI/APOLLO 50th_FULL COLOR_300DPI~thumb.jpg")
    static let url = URL(string: "https://images-assets.nasa.gov/image/APOLLO 50th_FULL COLOR_300DPI/APOLLO 50th_FULL COLOR_300DPI~thumb.jpg".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    static let nasaItems: [NasaItem] = [NasaItem(data: [data], links: [link])]
    static var description = try? data.description!.htmlToAttributedString()
    
    static let nasaListItem = NasaListItem(title: data.title, image: UIImage(systemName: "star")! , description: description!, dateCreated: data.date_created, nasaItem: NasaItem(data: [data], links: [link]))
    static let emptyNasaItems: [NasaItem] = []
}
