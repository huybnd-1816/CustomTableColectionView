//
//  BaseViewModel.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Foundation

enum Result {
    case success
    case failure(error: BaseError)
}

protocol BaseViewModel {
    func bind(didChange: @escaping (Result) -> Void)
    func reloadData()
}
