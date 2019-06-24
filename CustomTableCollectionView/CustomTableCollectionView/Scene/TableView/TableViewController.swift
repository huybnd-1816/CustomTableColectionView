//
//  ViewController.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {
    @IBOutlet private weak var speciesTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    private var vm: TableViewModel!
    private var bottomSpinner = CustomSpinner(frame: CGRect.zero)
    private var numberOfPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupTableView()
        setupRefreshControl()
    }
    
    private func config() {
        navigationItem.title = "Table View"
        vm = TableViewModel()
        vm.reloadData()
        
        vm.bind { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.speciesTableView.reloadData()
            case .failure(let error):
                self.showAlert(message: error.errorMessage ?? "Error")
            }
        }
        
        vm.didFinishRefreshing = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .topSpinner(let isRefreshing):
                if isRefreshing {
                    self.refreshControl.endRefreshing()
                } else {
                    self.refreshControl.beginRefreshing()
                }
            case .bottomSpinner(let isRefreshing):
                if isRefreshing {
                    self.bottomSpinner.stopAnimating()
                } else {
                    self.bottomSpinner.startAnimating()
                }
            }
        }
    }
    
    private func setupTableView() {
//        speciesTableView.register(UINib(nibName: "HeaderTableCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        speciesTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        speciesTableView.tableFooterView = UIView(frame: .zero)
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        speciesTableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
        // Table Cell Sizing
        speciesTableView.estimatedRowHeight = 45
        speciesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            speciesTableView.refreshControl = refreshControl
        } else {
            speciesTableView.insertSubview(refreshControl, at: 0)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red: 0.25, green: 0.72, blue: 0.85, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: nil)
    }
    
    @objc
    private func refreshData(_ sender: Any) {
        vm.reloadData()
    }
    
    @IBAction func handleEditButtonTapped(_ sender: Any) {
        speciesTableView.isEditing = !speciesTableView.isEditing
        print(speciesTableView.isEditing)
        editButton.title = speciesTableView.isEditing ? "Done" : "Edit"
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.speciesData[section].isExpanded {
            return vm.speciesData[section].species.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        let data = vm.speciesData[indexPath.section].species[indexPath.row]
        cell.configCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vm.speciesData[indexPath.section].isExpanded {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.speciesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // HeaderViewCell
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = speciesTableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader")
        let headerCell = cell as! TableSectionHeader
        headerCell.delegate = self
        headerCell.secIndex = section
        headerCell.contentView.backgroundColor = .cyan
        headerCell.configHeader(vm.speciesData[section].headerTitle)
        headerCell.collapseButton.setTitle(vm.speciesData[section].isExpanded ? "Collapse" : "Show", for: .normal)
        
        return headerCell
    }
    
    // FooterViewCell
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return bottomSpinner
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if speciesTableView.contentOffset.y >= (speciesTableView.contentSize.height - speciesTableView.frame.size.height + 64) {
            //you reached the bottom of tableview, you can append the other 10 numbers to array and do reload
            if numberOfPages < 4 {
                numberOfPages += 1
                loadMoreData(numOfPages: numberOfPages)
            } else {
                bottomSpinner.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = vm.speciesData[sourceIndexPath.section].species[sourceIndexPath.row]
        vm.speciesData[sourceIndexPath.section].species.remove(at: sourceIndexPath.row)
        vm.speciesData[sourceIndexPath.section].species.insert(item, at: destinationIndexPath.row)
    }
}

extension TableViewController {
    func loadMoreData(numOfPages: Int) {
        bottomSpinner.startAnimating()
        vm.loadMore(numOfPages)
    }
}

extension TableViewController: HeaderDelegate {
    func callHeader(_ index: Int) {
        // Implement collapse section
        let isExpanded = self.vm.speciesData[index].isExpanded
        vm.speciesData[index].isExpanded = !isExpanded
        
        let indexPaths = self.speciesTableView.indexPathsForVisibleRows
        self.speciesTableView.reloadRows(at: indexPaths!, with: .automatic)
    }
}
