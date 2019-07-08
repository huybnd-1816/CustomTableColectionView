//
//  SpeciesRepository.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

protocol JobsRepository {
    func fetchJobs(pageIndex: Int, completion: @escaping (BaseResult<[Job]>) -> Void)
}

final class JobsRepositoryImpl: JobsRepository {
    
    private var isCallingRequest: Bool = false
    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func fetchJobs(pageIndex: Int, completion: @escaping (BaseResult<[Job]>) -> Void) {
        let input = GetJobsRequest(pageIndex: pageIndex)
        
        guard !isCallingRequest else { return }
        
        isCallingRequest = true
        api?.request(input: input) { (object: [Job]?, error) in
            self.isCallingRequest = false
            
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
