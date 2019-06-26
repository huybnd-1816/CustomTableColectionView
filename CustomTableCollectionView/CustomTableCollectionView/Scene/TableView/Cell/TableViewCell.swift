//
//  TableViewCell.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    func configCell(_ dataCell: Job) {
        guard let title = dataCell.title,
            let description = dataCell.how_to_apply else { return }
        titleLabel.text = title
        detailLabel.text = description
    }
}
