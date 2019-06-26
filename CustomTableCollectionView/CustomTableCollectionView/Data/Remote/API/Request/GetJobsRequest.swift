//
//  GetSpeciesRequest.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Alamofire

final class GetJobsRequest: BaseRequest {
    
    required init(pageIndex: Int) {
        let parameters: [String: Any]  = [
            "page": pageIndex
        ]
        
        super.init(url: Urls.basePath + "positions.json", requestType: .get, parameters: parameters)
    }
}
