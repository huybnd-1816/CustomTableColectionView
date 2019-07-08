//
//  CollectionSectionHeader.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/27/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

protocol CollectionHeaderDelegate {
    func callHeader(_ secIndex: Int)
}

final class CollectionSectionHeader: UICollectionReusableView {
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    
    var delegate: CollectionHeaderDelegate!
    var secIndex: Int!
    
    func configCollectionHeader(_ headerText: String) {
        headerTitleLabel.text = headerText
    }
    
    @IBAction func handleCollapseButtonTapped(_ sender: Any) {
        delegate.callHeader(secIndex)
    }
}
