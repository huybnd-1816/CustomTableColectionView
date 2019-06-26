//
//  ViewController.swift
//  CustomTableCollectionView
//
//  Created by nguyen.duc.huyb on 6/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class TableViewController: UIViewController {
    @IBOutlet private weak var jobsTableView: UITableView!
    @IBOutlet private weak var editButton: UIBarButtonItem!
    
    private let refreshControl = UIRefreshControl()
    private let viewModel = TableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupTableView()
        setupRefreshControl()
    }
    
    private func config() {
        navigationItem.title = "Table View"
        editButton.isEnabled = false
        
        // Update view when reload data
        viewModel.didUpdateView = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.editButton.isEnabled = true
                self.jobsTableView.reloadData()
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
            let indexPaths = self.jobsTableView.indexPathsForVisibleRows
            self.jobsTableView.reloadRows(at: indexPaths!, with: .automatic)
            
            // If there are no visible cells then cannot editing
            self.editButton.isEnabled = indexPaths?.count == 0 ? false : true
        }
    }
    
    private func setupTableView() {
        jobsTableView.delegate = viewModel
        jobsTableView.dataSource = viewModel
        
        jobsTableView.register(UINib(nibName: "TableSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        jobsTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        jobsTableView.tableFooterView = UIView(frame: .zero)
        
        // Table Cell Sizing
        jobsTableView.estimatedRowHeight = 45
        jobsTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupRefreshControl() {
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            jobsTableView.refreshControl = refreshControl
        } else {
            jobsTableView.insertSubview(refreshControl, at: 0)
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
    
    @IBAction func handleEditButtonTapped(_ sender: Any) {
        jobsTableView.isEditing = !jobsTableView.isEditing
        editButton.title = jobsTableView.isEditing ? "Done" : "Edit"
    }
}
