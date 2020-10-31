//
//  ViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 19/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import Alamofire
import LUAutocompleteView
import TableFlip
import Crashlytics

class ViewController: UIViewController,
    UISearchBarDelegate,
    UITableViewDataSource, UITableViewDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LUAutocompleteViewDataSource, LUAutocompleteViewDelegate {
    var autocompleteRequest: DataRequest? = nil
    
    @IBOutlet weak var filterCounter: UILabel!
    var currentRequest: DataRequest? = nil
    var searchRequest = SearchRequest()
    var bottles: [Bottle]? = nil
    var count =  -1
    private var shouldShowLoadingCell = false
    @IBOutlet weak var bottlesTableView: UITableView!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var searchBox: UISearchBar!
    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var overlay: UIView!
    
    
    
    let categories = [Category(name: "Whisky", iconName: "category_whisky",width: 110.0),
                      Category(name: "Rum", iconName: "category_rum", width: 90.0),
                      Category(name: "Gin", iconName: "category_gin", width: 80.0),
                      Category(name: "Cognac", iconName: "category_cognac", width: 120.0),
                      Category(name: "Vodka", iconName: "category_vodka", width: 110.0),
                      Category(name: "Other Spirits", iconName: "category_other", width: 160.0),]
    
    let sortOptions = [SORT.NAME_ASC, SORT.NAME_DESC, SORT.PRICE_ASC, SORT.PRICE_DESC, SORT.AGE_ASC, SORT.AGE_DESC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        print(locale.regionCode)
        
        bottlesTableView.dataSource = self
        
        bottlesTableView.register(UINib(nibName: "BottleListItem",
                                        bundle: nil),
                                  forCellReuseIdentifier: "bottleListItem")
        bottlesTableView.register(UINib(nibName: "LoadingMoreTableViewCell",
                                        bundle: nil),
                                  forCellReuseIdentifier: "loadingCell")
        
        bottlesTableView.rowHeight = 144.0
        bottlesTableView.tableFooterView = UIView(frame: .zero)
        bottlesTableView.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        categoriesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        categoriesCollectionView.backgroundColor = nil
        categoriesCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.reloadData()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.titleView = categoriesCollectionView
        
        let autocompleteview = LUAutocompleteView()
        view.addSubview(autocompleteview)
        autocompleteview.textField = searchBox.textField
        autocompleteview.delegate = self
        autocompleteview.dataSource = self
        autocompleteview.layer.cornerRadius = 5
        
        searchRequest.sortBy = "RANDOM"
        searchBox.layer.borderColor = UIColor(hexString: "#596275").cgColor
        searchBox.layer.borderWidth = 1
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        searchBox.delegate = self
        
        loadInitialBottlesList()
        
        filterCounter.layer.masksToBounds = true
        filterCounter.layer.cornerRadius = 8
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    
    @IBAction func scanButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "scan", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        autocompleteRequest = nil
        if let query = searchBar.text {
            if (!query.isEmpty) {
                searchRequest.offset = 0
                searchRequest.name = query
                self.loadInitialBottlesList()
                searchBar.endEditing(true)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        scanButton.isHidden = true
    }
    
    var should = true
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = searchRequest.name
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        if let q = searchBar.text {
            if q.isEmpty {
                scanButton.isHidden = false
            }
        }
        should = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlay.alpha = 0
        })
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let res = should
        should = true
        return res
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.isEmpty && !searchRequest.name.isEmpty) {
            searchRequest.name = ""
            loadInitialBottlesList()
        } else if (searchText.isEmpty) {
            autocompleteRequest?.cancel()
            UIView.animate(withDuration: 0.3, animations: {
                self.overlay.alpha = 0
            })
        }
    }
    
    
    func loadInitialBottlesList() {
        AnalyticsManager.performSearch(searchRequest: searchRequest)
        searchBarCancelButtonClicked(searchBox)
        bottles = nil
        bottlesTableView.reloadData()
        view!.displayLoadingInView()
        getBottles()
        getCount()
    }
    
    @IBAction func displaySort(_ sender: Any) {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        for option in sortOptions {
            alert.addAction(UIAlertAction(title: NSLocalizedString(option.title(), comment: "Default action"), style: UIAlertActionStyle.default , handler: { _ in
                self.searchRequest.setSort(sort: option)
                self.searchRequest.offset = 0
                self.loadInitialBottlesList()
            }))
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: UIAlertActionStyle.destructive , handler: { _ in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getBottles() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlay.alpha = 0
        })
        errorContainer.isHidden = true
        currentRequest = Api.searchBottles(request: searchRequest) { (response) in
            self.searchBox.endEditing(true)
            if (self.bottles == nil) {
                self.bottles = response?.results
                self.shouldShowLoadingCell = self.bottles?.count == self.searchRequest.offset + self.searchRequest.limit
                self.bottlesTableView.reloadData()
                self.bottlesTableView.animate(animation: TableViewAnimation.Cell.fade(duration: 0.3))
                self.view!.hideLoadingInView()
                
            } else {
                self.bottles! += response!.results!
                self.shouldShowLoadingCell = self.bottles?.count == self.searchRequest.offset + self.searchRequest.limit
                self.bottlesTableView.reloadData()
            }
        }
        
        initFilterCount()
    }
    
    private func initFilterCount() {
        let filterCount = searchRequest.filterCount()
        if (filterCount == 0) {
            filterCounter.isHidden = true
        } else {
            filterCounter.isHidden = false
            filterCounter.text = String(filterCount)
        }
    }
    
    func getCount() {
        counter.text = "..."
        Api.getCount(request: searchRequest) { (response) in
            if let count = response {
                AnalyticsManager.searchResultsReceived(searchRequest: self.searchRequest, count: count)
                self.count = count
                self.counter.text = "\(count) Bottles"
                if (count == 0) {
                    if (!self.searchRequest.barcode.isEmpty) {
                        Api.getMissingBarcodeOptions(for: self.searchRequest.barcode, callback: { (res) in
                            if let title = res {
                                self.searchRequest.barcode = ""
                                self.searchRequest.name = title
                                self.loadInitialBottlesList()
                            } else {
                                self.view!.hideLoadingInView()
                                self.errorContainer.isHidden = false
                            }
                        })
                    } else {
                        self.view!.hideLoadingInView()
                        self.errorContainer.isHidden = false
                    }
                } else {
                    self.view!.hideLoadingInView()
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == bottles!.count - 5 &&
            bottles?.count != count &&
            bottles?.count == searchRequest.offset + searchRequest.limit {
            if (currentRequest!.progress.isFinished) {
                self.searchRequest.offset = bottles!.count
                print("Fetching \(searchRequest.offset) - \(searchRequest.offset + searchRequest.limit)")
                getBottles()
            }
        }
        
        if (isLoadingIndexPath(indexPath)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell",
                                                     for: indexPath) as! LoadingMoreTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottleListItem",
                                                     for: indexPath) as! BottleListItem
            cell.bind(bottle: bottles![indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isLoadingIndexPath(indexPath)) {
            return 44.0
        } else {
            return 144.0
        }
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.bottles!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = bottles?.count {
            return shouldShowLoadingCell ? count + 1 : count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bottle = bottles?[indexPath.row]
        AnalyticsManager.bottleClicked(bottleId: bottle!.id)
        performSegue(withIdentifier: "viewBottle", sender: bottle)
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        searchRequest.sortBy = "name"
        self.searchRequest.barcode = ""
        searchRequest.offset = 0
        searchRequest.name = text
        self.loadInitialBottlesList()
        self.view.endEditing(true)
    }
    
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        autocompleteRequest?.cancel()
        if (!text.isEmpty) {
            autocompleteRequest = Api.getAutoCompleteOptions(for: text) { (response) in
                if self.autocompleteRequest != nil {
                    if (self.overlay.alpha != 1) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.overlay.alpha = 1
                        })
                    }
                    var options = [String]()
                    options.append(text)
                    options.append(contentsOf: response)
                    completion(options)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categories[indexPath.row].width, height: 32.0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchRequest.category.removeAll()
        searchRequest.category.append(categories[indexPath.row].name!)
        searchRequest.sortBy = "RANDOM"
        searchRequest.setDeliveryCountry()
        self.searchRequest.barcode = ""
        self.loadInitialBottlesList()
        categoriesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell",
                                                      for: indexPath) as! CategoryCollectionViewCell
        
        let category = categories[indexPath.row]
        cell.bind(text: category.name!, iconName: category.iconName, selected: searchRequest.category[0] == category.name!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "openFilter":
            let backButton = UIBarButtonItem()
            backButton.title = "Cancel"
            navigationItem.backBarButtonItem = backButton
            let vc = segue.destination as! FilterViewControllerTableViewController
            vc.searchRequest = self.searchRequest.clone()
            vc.delegate = {(sr) in
                AnalyticsManager.searchApplyFilter(searchRequest: sr)
                self.searchRequest = sr
                self.searchRequest.offset = 0
                self.loadInitialBottlesList()
            }
            break
        case "viewBottle":
            navigationItem.backBarButtonItem = nil
            let vc = segue.destination as! ViewBottleTwo
            if let bottle = sender as? Bottle {
                vc.bottle = bottle
            } else if let bottleId = sender as? Int {
                vc.bottleId = bottleId
            }
            tabBarController?.tabBar.isHidden = true
            break
        case "scan":
            navigationItem.backBarButtonItem = nil
            let vc = segue.destination as! BarcodeScannerViewController
            vc.delegate = {(barcode) in
                self.searchRequest = SearchRequest()
                self.searchRequest.category.removeAll()
                self.searchRequest.sortBy = "name"
                self.searchRequest.sortOrder = "ASC"
                self.searchRequest.barcode = barcode
                self.loadInitialBottlesList()
            }
            tabBarController?.tabBar.isHidden = true
            break
        default:
            break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
