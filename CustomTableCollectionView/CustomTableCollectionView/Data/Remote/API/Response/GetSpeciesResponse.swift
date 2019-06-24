//
//  GetSpeciesResponse.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct GetSpeciesResponse : Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Results]?
    
    enum CodingKeys: CodingKey {
        case count
        case next
        case previous
        case results
    }
}

