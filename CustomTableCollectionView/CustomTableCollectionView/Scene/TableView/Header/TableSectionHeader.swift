//
//  TableSectionHeader.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit


class TableSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    
    var secIndex: Int!
    var delegate: HeaderDelegate!
    
    func configHeader(_ headerText: String) {
        titleLabel.text = headerText
    }
    
    @IBAction func handleCollapseButtonTapped(_ sender: Any) {
        if let index = secIndex {
            delegate.callHeader(index)
        }
    }
}
