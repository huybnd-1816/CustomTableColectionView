//
//  HeaderTableCell.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

protocol HeaderDelegate {
    func callHeader(_ index: Int)
}

final class HeaderTableCell: UITableViewCell {
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet weak var collapseButton: UIButton!
    
    var secIndex: Int!
    var delegate: HeaderDelegate!
    
    func configHeader(_ headerText: String) {
        headerTitleLabel.text = headerText
    }
    
    @IBAction func handleCollapseButtonTapped(_ sender: UIButton) {
        if let index = secIndex {
            delegate.callHeader(index)
        }
    }
}
