//
//  TableViewModel.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import Foundation

final class TableViewModel: BaseViewModel {
    override init() {
        super.init()
        reloadData()
    }
}

extension TableViewModel: UITableViewDelegate {
    
    // HeaderViewCell
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let headerCell = cell as! TableSectionHeader
        headerCell.delegate = self
        headerCell.secIndex = section
        headerCell.contentView.backgroundColor = .cyan
        headerCell.configTableHeader(jobsSection[section].headerTitle)
        headerCell.collapseButton.setTitle(jobsSection[section].isExpanded ? "Collapse" : "Show", for: .normal)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // FooterViewCell
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return bottomSpinner
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if bottomSpinner.isAnimating {
//            return 44
//        } else {
//             return 0
//        }
//    }
}

extension TableViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jobsSection[section].isExpanded {
            return jobsSection[section].jobs.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return jobsSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        let data = jobsSection[indexPath.section].jobs[indexPath.row]
        cell.configCell(data)
        return cell
    }
    
    // Move cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = jobsSection[sourceIndexPath.section].jobs[sourceIndexPath.row]
        jobsSection[sourceIndexPath.section].jobs.remove(at: sourceIndexPath.row)
        jobsSection[destinationIndexPath.section].jobs.insert(item, at: destinationIndexPath.row)
    }
}

extension TableViewModel: TableHeaderDelegate {
    func callHeader(_ index: Int) {
        // Implement collapse selected section
        let isExpanded = jobsSection[index].isExpanded
        jobsSection[index].isExpanded = !isExpanded
        
        reloadSections?(index)
    }
}

extension TableViewModel {
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
