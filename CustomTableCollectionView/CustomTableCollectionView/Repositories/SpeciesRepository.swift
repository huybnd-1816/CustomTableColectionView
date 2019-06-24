//
//  SpeciesRepository.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

protocol SpeciesRepository {
    func fetchSpecies(pageIndex: Int, completion: @escaping (BaseResult<GetSpeciesResponse>) -> Void)
}

final class SpeciesRepositoryImpl: SpeciesRepository {
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func fetchSpecies(pageIndex: Int, completion: @escaping (BaseResult<GetSpeciesResponse>) -> Void) {
        let input = GetPhotosRequest(pageIndex: pageIndex)
        
        api?.request(input: input) { (object: GetSpeciesResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
