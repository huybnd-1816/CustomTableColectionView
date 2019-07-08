//
//  CollectionViewCell.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    func configCell(_ dataCell: Job) {
        guard let title = dataCell.title,
            let description = dataCell.how_to_apply else { return }
        titleLabel.text = title
        detailLabel.text = description
    }
    
    // Self Sizing in collectionViewCell
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        // Invalidates the current layout of the receiver and triggers a layout update during the next update cycle.
        setNeedsLayout()
        // Redraw of a view and its subviews immediately without waiting for the update cycle
        layoutIfNeeded()
        
        // returns a size value for the view that optimally satisfies the contentView's current constraints
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size) // height = 129
        
        // Set new size height for contentView
        var frame = layoutAttributes.frame
        frame.size.height = size.height
        
        // Change layout frame height from 100 -> 129 to fit content
        layoutAttributes.frame = frame

        return layoutAttributes
    }
}
