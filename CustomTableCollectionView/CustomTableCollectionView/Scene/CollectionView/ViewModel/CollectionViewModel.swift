//
//  CollectionViewModel.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import Foundation

final class CollectionViewModel: BaseViewModel {
    override init() {
        super.init()
        reloadData()
    }
}

extension CollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if jobsSection[section].isExpanded {
            return jobsSection[section].jobs.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        let data = jobsSection[indexPath.section].jobs[indexPath.row]
        cell.configCell(data)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return jobsSection.count
    }
    
    // Header Footer CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderCell", for: indexPath) as! CollectionSectionHeader
            headerView.configCollectionHeader(jobsSection[indexPath.section].headerTitle)
            headerView.delegate = self
            headerView.secIndex = indexPath.section
            headerView.collapseButton.setTitle(jobsSection[indexPath.section].isExpanded ? "Collapse" : "Show", for: .normal)
            headerView.backgroundColor = .cyan
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "CollectionFooterCell",
                for: indexPath)
            footerView.addSubview(bottomSpinner)
            return footerView
        default:
            // Invalid element type
            assert(false)
        }
    }
    
    // Move cell
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = jobsSection[sourceIndexPath.section].jobs[sourceIndexPath.row]
        jobsSection[sourceIndexPath.section].jobs.remove(at: sourceIndexPath.row)
        jobsSection[destinationIndexPath.section].jobs.insert(item, at: destinationIndexPath.row)
    }
}

extension CollectionViewModel: UICollectionViewDelegateFlowLayout {
    // Margin content in section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    // Size for item
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: collectionView.frame.width - 32, height: 100)
//    }
}

extension CollectionViewModel {
    // Loadmore
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // If section is not expand -> no loadmore
        guard jobsSection.first?.isExpanded == true else { return }

        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if numberOfPages < 4 {
                numberOfPages += 1
                loadMore(numberOfPages)
            } else {
                bottomSpinner.stopAnimating()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) {
            bottomSpinner.stopAnimating()
        }
    }
}

extension CollectionViewModel: CollectionHeaderDelegate {
    func callHeader(_ index: Int) {
        // Implement collapse selected section
        let isExpanded = jobsSection[index].isExpanded
        jobsSection[index].isExpanded = !isExpanded
        
        reloadSections?(index)
    }
}
