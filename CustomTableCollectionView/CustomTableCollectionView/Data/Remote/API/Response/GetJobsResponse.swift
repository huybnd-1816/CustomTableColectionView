//
//  GetJobsResponse.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 7/1/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

struct Job: Codable {
    let id: String?
    let type: String?
    let url: String?
    let created_at: String?
    let company: String?
    let company_url: String?
    let location: String?
    let title: String?
    let description: String?
    let how_to_apply: String?
    let company_logo: String?
    
    enum CodingKeys: CodingKey {
        case id
        case type
        case url
        case created_at
        case company
        case company_url
        case location
        case title
        case description
        case how_to_apply
        case company_logo
    }
}
