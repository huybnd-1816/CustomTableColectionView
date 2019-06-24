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
    
    func configCell(_ dataCell: Results) {
        guard let created = dataCell.created,
            let edited = dataCell.edited else { return }
        titleLabel.text = dataCell.name
        detailLabel.text = created + " " + edited
    }
}
