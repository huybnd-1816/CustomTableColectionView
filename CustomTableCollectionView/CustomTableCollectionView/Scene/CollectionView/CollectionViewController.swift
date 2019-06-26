//
//  CollectionViewController.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class CollectionViewController: UIViewController {
    @IBOutlet private weak var jobsCollectionView: UICollectionView!
    @IBOutlet private weak var switchButton: UIBarButtonItem!
    
    private var viewModel: CollectionViewModel!
    private let refreshControl = UIRefreshControl()
    
    private var layoutIsChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupCollectionView()
        setupRefreshControl()
    }
    
    private func config() {
        navigationItem.title = "Collection view"
        viewModel = CollectionViewModel()
        switchButton.isEnabled = false
        
        // Update view when reload data
        viewModel.didUpdateView = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchButton.isEnabled = true
                self.jobsCollectionView.reloadData()
            case .failure(let error):
                self.showAlert(message: error.errorMessage ?? "Error")
            }
        }
        
        // Show/Hide refresh control when pull to refresh
        viewModel.didFinishRefreshing = { [weak self] result in
            guard let self = self else { return }
            
            if result {
                self.refreshControl.endRefreshing()
            } else {
                self.refreshControl.beginRefreshing()
            }
        }
        
        // Show/Collapse rows in section
        viewModel.reloadSections = { [weak self] sectionIndex in
            guard let self = self else { return }
            
            let numberOfItems = self.jobsCollectionView.numberOfItems(inSection: sectionIndex)
            
            UIView.performWithoutAnimation {
                self.jobsCollectionView.reloadSections([sectionIndex])
            }
            
            // If there are no visible cells then cannot editing
            self.switchButton.isEnabled = numberOfItems == 0 ? false : true
        }
        
        // Move Item Action
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        longPressGesture.minimumPressDuration = 1.0
        jobsCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = jobsCollectionView.indexPathForItem(at: gesture.location(in: jobsCollectionView)) else {
                break
            }
            jobsCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed: jobsCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            jobsCollectionView.endInteractiveMovement()
        default:
            jobsCollectionView.cancelInteractiveMovement()
        }
    }
    
    private func setupCollectionView() {
        jobsCollectionView.dataSource = viewModel
        jobsCollectionView.delegate = viewModel
        jobsCollectionView.register(UINib(nibName: "CollectionSectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderCell")
        jobsCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        
        // Set estimatedSize for collection cell
        if let flowLayout = jobsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionView = jobsCollectionView {
            let width = collectionView.frame.width - 16 // 16 = 8 left margin + 8 right margin
            flowLayout.estimatedItemSize = CGSize(width: width, height: 100)
        }
    }
    
    private func setupRefreshControl() {
        // Add Refresh Control to Collection View
        if #available(iOS 10.0, *) {
            jobsCollectionView.refreshControl = refreshControl
        } else {
            jobsCollectionView.insertSubview(refreshControl, at: 0)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: nil)
    }
    
    @objc
    private func refreshData(_ sender: Any) {
        viewModel.reloadData()
    }
    
    @IBAction func handleSwitchButtonTapped(_ sender: Any) {
        guard let newLayout = jobsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let small = CGSize(width: (UIScreen.main.bounds.width / 2) - 32, height: 200)
        let big = CGSize(width: UIScreen.main.bounds.width - 16, height: 100)
        layoutIsChanged = !layoutIsChanged
        newLayout.estimatedItemSize = layoutIsChanged ? small : big
        
        jobsCollectionView.setCollectionViewLayout(newLayout, animated: true)
    }
}
