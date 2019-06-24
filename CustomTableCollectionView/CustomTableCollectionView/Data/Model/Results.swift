//
//  Album.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Foundation
struct Results: Codable {
    let name: String?
    let classification: String?
    let designation: String?
    let average_height: String?
    let skin_colors: String?
    let hair_colors: String?
    let eye_colors: String?
    let average_lifespan: String?
    let homeworld: String?
    let language: String?
    let people: [String]?
    let films: [String]?
    let created: String?
    let edited: String?
    let url: String?
    
    enum CodingKeys: CodingKey {
        case name
        case classification
        case designation
        case average_height
        case skin_colors
        case hair_colors
        case eye_colors
        case average_lifespan
        case homeworld
        case language
        case people
        case films
        case created
        case edited
        case url
    }
}
