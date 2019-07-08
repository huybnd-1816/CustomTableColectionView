//
//  CustomSpinner.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class CustomSpinner: UIActivityIndicatorView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.style = .gray
        self.stopAnimating()
        self.hidesWhenStopped = true
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(44))
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
