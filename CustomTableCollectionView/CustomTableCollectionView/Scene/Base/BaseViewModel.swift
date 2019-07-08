//
//  BaseViewModel.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import Foundation

enum Result {
    case success
    case failure(error: BaseError)
}

class BaseViewModel: NSObject {
    private let repoRepository = JobsRepositoryImpl(api: APIService.shared)
    var bottomSpinner = CustomSpinner(frame: CGRect.zero)
    
    var didFinishRefreshing: ((Bool) -> Void)?
    var didUpdateView: ((Result) -> Void)?
    var didFinishBottomSpinner: ((Bool) -> Void)?
    var reloadSections: ((Int) -> Void)?
    
    var numberOfPages = 0
    var jobsSection: [JobsSection] = [] {
        didSet {
            self.didUpdateView?(.success)
        }
    }
    
    func reloadData() {
        numberOfPages = 0
        didFinishRefreshing?(false)
        repoRepository.fetchJobs(pageIndex: numberOfPages) { [weak self] result in
            guard let self = self else { return }
            self.didFinishRefreshing?(true)
            
            switch result {
            case .success(let response):
                guard let data = response else { return }
                
                self.jobsSection.removeAll()
                let item = JobsSection(headerTitle: "Header", isExpanded: true, jobs: data)
                self.jobsSection.append(item)
            case .failure(let error):
                self.didUpdateView?(.failure(error: error!))
            }
        }
    }
    
    func loadMore(_ pageIndex: Int) {
        bottomSpinner.startAnimating()
        
        repoRepository.fetchJobs(pageIndex: pageIndex) { [weak self] result in
            guard let self = self else { return }
            self.bottomSpinner.stopAnimating()
            
            switch result {
            case .success(let response):
                guard let data = response else { return }
                data.forEach {
                    self.jobsSection[0].jobs.append($0)
                }
            case .failure(let error):
                self.didUpdateView?(.failure(error: error!))
            }
        }
    }
}
