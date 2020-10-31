//
//  FilterViewControllerTableViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class FilterViewControllerTableViewController: UITableViewController {
    var delegate: (SearchRequest) -> Void = {(_) in}
    var rangeDelegate: (Int, Int) -> Void = {(_, _) in}
    
    var multipleSelectionDelegate: ([String]) -> Void = {(_) in}
    var searchRequest: SearchRequest = SearchRequest()
    
    var filterData = [[(title: String, value: String)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(FilterViewControllerTableViewController.done))
        
        tableView.rowHeight = 56.0
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "FilterTableViewCell", bundle: nil), forCellReuseIdentifier: "filterTableViewCell")
    }
    
    @objc func done(sender: Any?) {
        delegate(searchRequest)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initFilterData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func initFilterData() {
        filterData = [[(title: String, value: String)]]()
        var array = [(title: String, value: String)]()
        
        array.append((title: "Currency", value: searchRequest.currency))
        if (searchRequest.deliveryCountry.count > 0) {
            array.append((title: "Delivery Country", value: UserSettings.getCountryName(for: searchRequest.deliveryCountry[0]) ))
        } else {
            array.append((title: "Delivery Country", value: "Any"))
        }
        filterData.append(array)
        
        array.removeAll()
        array.append((title: "Sub-Category", value: getValueFromArray(array: searchRequest.subcategory)))
        array.append((title: "Country", value: getValueFromArray(array: searchRequest.country)))
        array.append((title: "Region", value: getValueFromArray(array: searchRequest.region)))
        filterData.append(array)
        
        array.removeAll()
        array.append((title: "Brand", value: getValueFromArray(array: searchRequest.brand)))
        array.append((title: "Bottled By", value: getValueFromArray(array: searchRequest.bottler)))
        filterData.append(array)
        
        array.removeAll()
        array.append((title: "Price Range", value: getValueForRange(from: searchRequest.minPrice, to: searchRequest.maxPrice, suffix: "", prefix: Constants.getCurrencySymbol())))
        array.append((title: "ABV", value: getValueForRange(from: searchRequest.minABV, to: searchRequest.maxABV, suffix: "%", prefix: "")))
        array.append((title: "Age", value: getValueForRange(from: searchRequest.minAge, to: searchRequest.maxAge, suffix: "yo", prefix: "")))
        array.append((title: "Vintage", value: getValueForRange(from: searchRequest.minDistillationYear, to: searchRequest.maxDistillationYear, suffix: "", prefix: "")))
        array.append((title: "Bottling Year", value: getValueForRange(from: searchRequest.minBottlingYear, to: searchRequest.maxBottlingYear, suffix: "", prefix: "")))
        filterData.append(array)
        
        array.removeAll()
        array.append((title: "Matured/Finished In", value: getValueFromArray(array: searchRequest.exLiquid)))
        array.append((title: "Cask Size", value: getValueFromArray(array: searchRequest.caskSize)))
        array.append((title: "Wood Type", value: getValueFromArray(array: searchRequest.wood)))
        array.append((title: "Cask Refill", value: getValueFromArray(array: searchRequest.refill)))
        filterData.append(array)
        
        tableView.reloadData()
    }
    
    private func getValueFromArray(array: [String]) -> String {
        var value = "Any"
        if (!array.isEmpty) {
            value = array[0]
            if (array.count > 1) {
                value += ", +\(array.count - 1) more"
            }
        }
        
        return value
    }
    
    private func getValueForRange(from: Int, to: Int, suffix: String, prefix: String) -> String {
        if (from == -1 && to == -1) {
            return "Any"
        }
        if (from == -1 && to != -1) {
            return "Up to " + (prefix + String(to) + suffix)
        }
        if (from != -1 && to == -1) {
            return "At least " + (prefix + String(from) + suffix)
        }
        
        let fromVal = from == -1 ? "Any" : (prefix + String(from) + suffix)
        let toVal = to == -1 ? "Any" : (prefix + String(to) + suffix)
        
        if (fromVal == toVal) {
            return fromVal
        }
        
        return fromVal + " - " + toVal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return filterData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filterData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterTableViewCell", for: indexPath) as! FilterTableViewCell
        
        cell.title.text = filterData[indexPath.section][indexPath.row].title
        cell.value.text = filterData[indexPath.section][indexPath.row].value
        
        if (filterData[indexPath.section][indexPath.row].value != "Any") {
            cell.value.textColor = UIColor(hexString: "#596275")
            cell.value.font = UIFont.boldSystemFont(ofSize: cell.value.font.pointSize)
        } else {
            cell.value.textColor = nil
            cell.value.font = nil
        }
        
        if (indexPath.section == 0 && indexPath.row == 2 && searchRequest.country.isEmpty) {
            cell.disable()
        } else {
            cell.enable()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == filterData.count - 1 {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 56.0))
            button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
            button.setTitle("Clear Filter", for: .normal)
            button.setTitleColor(UIColor.red, for: .normal)
            button.addTarget(self, action: #selector(FilterViewControllerTableViewController.clearFilter(_:)), for: .touchUpInside)
            return button
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == filterData.count - 1 {
            return 56.0
        } else {
            return 0.0
        }
    }
    
    @objc func clearFilter(_ sender:UIButton!) {
        let name = searchRequest.name
        let sortBy = searchRequest.sortBy
        let sortOrder = searchRequest.sortOrder
        let barcode = searchRequest.barcode
        let category = searchRequest.category
        
        searchRequest = SearchRequest()
        searchRequest.name = name
        searchRequest.sortOrder = sortOrder
        searchRequest.sortBy = sortBy
        searchRequest.barcode = barcode
        searchRequest.category = category
        initFilterData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                openCurrencyDialog()
                break
            case 1:
                openDeliveryCountryPicker()
                break
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                openSubCategory()
                break
            case 1:
                openCountry()
                break
            case 2:
                if (!searchRequest.country.isEmpty) {
                    openRegions()
                }
                break
            default:
                break
            }
            break
        case 2:
            switch indexPath.row {
            case 0:
                openBrand()
                break
            case 1:
                openBottler()
                break
            default:
                break
            }
            break
        case 3:
            switch indexPath.row {
            case 0:
                openPriceRange()
                break
            case 1:
                openAbvRange()
                break
            case 2:
                openAgeRange()
                break
            case 3:
                openVintageRange()
                break
            case 4:
                openBottlingDateRange()
                break
            default:
                break
            }
            break
        case 4:
            switch indexPath.row {
            case 0:
                openCaskType()
                break
            case 1:
                openCaskSize()
                break
            case 2:
                openWoodType()
                break
            case 3:
                openCaskRefill()
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "multipleSelection":
            let data = sender as! ([String], [String], String)
            let vc = segue.destination as! FilterMultipleSelectionViewController
            vc.options = data.0
            vc.selected = data.1
            vc.title = data.2
            vc.multipleSelectionDelegate = self.multipleSelectionDelegate
            let backButton = UIBarButtonItem()
            backButton.title = "Cancel"
            navigationItem.backBarButtonItem = backButton
            break
        case "range":
            let data = sender as! (RangeType, String, Int, Int)
            let vc = segue.destination as! FilterRangeViewController
            vc.rangeType = data.0
            vc.min = data.2
            vc.max = data.3
            vc.title = data.1
            vc.rangeDelegate = self.rangeDelegate
            break
        default:
            break
        }
    }
}

extension FilterViewControllerTableViewController {
    private func openCurrencyDialog() {
        let dataSource = CurrencyDataSource()
        let alert = UIAlertController(title: "Currency", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerView = UIPickerView(frame: CGRect(x: 50, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerView)
        pickerView.dataSource = dataSource
        pickerView.delegate = dataSource
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let currency = dataSource.choices[pickerView.selectedRow(inComponent: 0)]
            self.searchRequest.currency = currency
            self.initFilterData()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
        pickerView.selectRow(dataSource.choices.firstIndex(of: searchRequest.currency)!, inComponent: 0, animated: false)
        
        self.present(alert,animated: true, completion: nil )
    }
    
    func openDeliveryCountryPicker() {
        let dataSource = DeliveryCountryDataSource()
        let alert = UIAlertController(title: "Delivery Country", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        let pickerView = UIPickerView(frame: CGRect(x: 50, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerView)
        pickerView.dataSource = dataSource
        pickerView.delegate = dataSource
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let country = dataSource.getCountryCode(forRow: pickerView.selectedRow(inComponent: 0))
            self.searchRequest.deliveryCountry.removeAll()
            self.searchRequest.deliveryCountry.append(country)
            self.initFilterData()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
        var selectedItem = 0
        if (!searchRequest.deliveryCountry.isEmpty) {
            selectedItem = dataSource.countriesNames.firstIndex(of: UserSettings.getCountryName(for: searchRequest.deliveryCountry[0]))!
        }
        pickerView.selectRow(selectedItem, inComponent: 0, animated: false)
        
        self.present(alert,animated: true, completion: nil )
    }
    
    
    func openSubCategory() {
        displayLoadingDialog()
        Api.getCategories() { (categories) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.subcategory = selected
            }
            let category = categories.filter({$0.name == self.searchRequest.category[0]})
            category[0].subcategories!.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (category[0].subcategories!, self.searchRequest.subcategory, "Sub-Category"))
        }
    }
    
    func openCountry() {
        displayLoadingDialog()
        Api.getCountries() { (countries) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.country = selected
            }
            var mutableCountries = [Country]()
            mutableCountries.append(contentsOf: countries)
            var options = mutableCountries.sorted(by: { $0.count > $1.count }).map({$0.name!})
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.country, "Country"))
        }
    }
    
    func openRegions() {
        displayLoadingDialog()
        Api.getRegions() { (regions) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.region = selected
            }
            
            var options = [String]()
            if (!self.searchRequest.country.isEmpty) {
                var countries = regions.filter({self.searchRequest.country.contains($0.country!)})
                options = countries.map({$0.region!})
            } else {
                options = regions.map({$0.region!})
            }
            
            options.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.region, "Region"))
        }
    }
    
    func openBrand() {
        displayLoadingDialog()
        var sr = searchRequest.clone()
        sr.bottler.removeAll()
        sr.brand.removeAll()
        Api.getBrands(request: sr) { (brands) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(brands) in
                self.searchRequest.brand = brands
            }
            self.performSegue(withIdentifier: "multipleSelection", sender: (brands, self.searchRequest.brand, "Brand"))
        }
    }
    
    func openBottler() {
        displayLoadingDialog()
        var sr = searchRequest.clone()
        sr.bottler.removeAll()
        sr.brand.removeAll()
        Api.getBottlers(request: sr) { (bottlers) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.bottler = selected
            }
            self.performSegue(withIdentifier: "multipleSelection", sender: (bottlers, self.searchRequest.bottler, "Bottled By"))
        }
    }
    
    func openCaskType() {
        displayLoadingDialog()
        Api.getCasks() { (casks) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.exLiquid = selected
            }
            
            var options = casks[0].exLiquid!
            options.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.exLiquid, "Matured/Finished In"))
        }
    }
    
    func openWoodType() {
        displayLoadingDialog()
        Api.getCasks() { (casks) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.wood = selected
            }
            
            var options = casks[0].wood!
            options.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.wood, "Wood Type"))
        }
    }
    
    func openCaskSize() {
        displayLoadingDialog()
        Api.getCasks() { (casks) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.caskSize = selected
            }
            var options = casks[0].caskSize!
            options.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.caskSize, "Cask Size"))
        }
    }
    
    func openCaskRefill() {
        displayLoadingDialog()
        Api.getCasks() { (casks) in
            self.hideLoadingDialog()
            self.multipleSelectionDelegate = {(selected) in
                self.searchRequest.refill = selected
            }
            var options = casks[0].refill!
            options.sort()
            self.performSegue(withIdentifier: "multipleSelection", sender: (options, self.searchRequest.refill, "Refill"))
        }
    }
    
    func openPriceRange() {
        rangeDelegate = {(min, max) in
            self.searchRequest.minPrice = min
            self.searchRequest.maxPrice = max
            self.initFilterData()
        }
        
        openRangeDialog(title: "Price Range", rangeType: .PRICE, min: searchRequest.minPrice, max: searchRequest.maxPrice)
    }
    
    func openAbvRange() {
        rangeDelegate = {(min, max) in
            self.searchRequest.minABV = min
            self.searchRequest.maxABV = max
            self.initFilterData()
        }
        
        openRangeDialog(title: "ABV", rangeType: .ABV, min: searchRequest.minABV, max: searchRequest.maxABV)
    }
    
    func openAgeRange() {
        rangeDelegate = {(min, max) in
            self.searchRequest.minAge = min
            self.searchRequest.maxAge = max
            self.initFilterData()
        }
        openRangeDialog(title: "Age", rangeType: .AGE, min: searchRequest.minAge, max: searchRequest.maxAge)
    }
    
    func openVintageRange() {
        rangeDelegate = {(min, max) in
            self.searchRequest.minDistillationYear = min
            self.searchRequest.maxDistillationYear = max
            self.initFilterData()
        }
        openRangeDialog(title: "Vintage", rangeType: .YEAR, min: searchRequest.minDistillationYear, max: searchRequest.maxDistillationYear)
    }
    
    func openBottlingDateRange() {
        rangeDelegate = {(min, max) in
            self.searchRequest.minBottlingYear = min
            self.searchRequest.maxBottlingYear = max
            self.initFilterData()
        }
        openRangeDialog(title: "Bottling Year", rangeType: .YEAR, min: searchRequest.minBottlingYear, max: searchRequest.maxBottlingYear)
    }
    
    func openRangeDialog(title: String, rangeType: RangeType, min: Int, max: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "rangeDialog") as! FilterRangeViewController
        vc.rangeType = rangeType
        vc.min = min
        vc.max = max
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let editRadiusAlert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done",
                                                style: .default,
                                                handler: {(_) in self.handleRangeDialogSelection(dialog: vc)}))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    func handleRangeDialogSelection(dialog: FilterRangeViewController) {
        let selection = dialog.getSelection()
        self.rangeDelegate(selection.min, selection.max)
    }
}
