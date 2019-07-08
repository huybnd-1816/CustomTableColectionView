//
//  TableSectionHeader.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

protocol TableHeaderDelegate {
    func callHeader(_ secIndex: Int)
}

class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    
    var secIndex: Int!
    var delegate: TableHeaderDelegate!
    
    func configTableHeader(_ headerText: String) {
        titleLabel.text = headerText
    }
    
    @IBAction func handleCollapseButtonTapped(_ sender: Any) {
        delegate.callHeader(secIndex)
    }
}
