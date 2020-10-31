//
//  FilterMultipleSelectionViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 30/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class FilterMultipleSelectionViewController: UITableViewController, UISearchResultsUpdating {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var multipleSelectionDelegate: ([String]) -> Void = {(_) in}
    var options = [String]()
    var selected = [String]()
    private var filteredOptions = [String]()
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(FilterMultipleSelectionViewController.done))
        
        tableView.allowsMultipleSelection = true
        
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "FilterOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "filterOption")
        tableView.reloadData()
        
        configSearchBar()
    }
    
    private func configSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor(hexString: "#596275")
        searchController.searchBar.barTintColor = UIColor(hexString: "#596275")
        searchController.searchBar.backgroundColor = UIColor(hexString: "#596275")
        searchController.searchBar.layer.borderColor = UIColor(hexString: "#596275").cgColor
        searchController.searchBar.layer.borderWidth = 1
//        (searchController.searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("Done", for: .normal)
        
        tableView.backgroundView = UIView()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredOptions.count : options.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOption", for: indexPath) as! FilterOptionTableViewCell

        let value = searchController.isActive ? filteredOptions[indexPath.row] : options[indexPath.row]
        cell.title.text = value
        
        if (selected.contains(value)) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        }
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterSearchController(searchController.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
            filterSearchController(searchController.searchBar)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = searchController.isActive ? filteredOptions[indexPath.row] : options[indexPath.row]
        selected.append(value)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let value = searchController.isActive ? filteredOptions[indexPath.row] : options[indexPath.row]
        selected.remove(at: selected.index(of: value)!)
    }
    
    private func filterSearchController(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        filteredOptions = options.filter { opt in
            let isMatchingSearchText = opt.lowercased().contains(searchText.lowercased()) || searchText.lowercased().count == 0
            return isMatchingSearchText
        }
        tableView.reloadData()
    }
    
    @objc func done(sender: Any?) {
        multipleSelectionDelegate(selected)
        navigationController?.popViewController(animated: true)
    }
}
