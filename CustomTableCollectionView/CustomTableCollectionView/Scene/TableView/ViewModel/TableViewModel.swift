//
//  TableViewModel.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

enum RefreshType {
    case topSpinner(Bool)
    case bottomSpinner(Bool)
}

class TableViewModel: BaseViewModel {
    private let repoRepository = SpeciesRepositoryImpl(api: APIService.shared)
    
    var speciesData: [SpeciesSection] = [] {
        didSet {
            self.didChange?(.success)
        }
    }
    
    private var didChange: ((Result) -> Void)?
    var didFinishRefreshing: ((RefreshType) -> Void)?
    
    func bind(didChange: @escaping (Result) -> Void) {
        self.didChange = didChange
    }
    
    func reloadData() {
        didFinishRefreshing?(.topSpinner(false))
        repoRepository.fetchSpecies(pageIndex: 1) { [weak self] result in
            guard let self = self else { return }
            self.didFinishRefreshing?(.topSpinner(true))
            
            switch result {
            case .success(let response):
                guard let data = response?.results else { return }
                
                self.speciesData.removeAll()
                let item = SpeciesSection(headerTitle: "Header", isExpanded: true, species: data)
                self.speciesData.append(item)
            case .failure(let error):
                self.didChange?(.failure(error: error!))
            }
        }
    }
    
    func loadMore(_ pageIndex: Int) {
        didFinishRefreshing?(.bottomSpinner(false))
        repoRepository.fetchSpecies(pageIndex: pageIndex) { [weak self] result in
            guard let self = self else { return }
            self.didFinishRefreshing?(.bottomSpinner(true))
            
            switch result {
            case .success(let response):
                guard let data = response?.results else { return }
                data.forEach {
                    self.speciesData[0].species.append($0)
                }
            case .failure(let error):
                self.didChange?(.failure(error: error!))
            }
        }
    }
}
