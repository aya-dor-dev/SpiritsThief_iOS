//
//  ViewBottleTwo.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 05/09/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class ViewBottleTwo: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, StoresTableViewCellDelegate, BarcodeAlertViewDelegate {
    
    var bottleId: Int = -1
    var bottle: Bottle?
    var stores: SortedStores? = nil
    var infoData = [[(String, String)]]()
    
    @IBOutlet weak var imageGallery: UICollectionView!
    @IBOutlet weak var bottleIntoTableView: UITableView!
    @IBOutlet weak var bottleStyle: UILabel!
    @IBOutlet weak var wishListButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var collectionBottle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottleIntoTableView.isHidden = true
        if (bottle != nil) {
            getStores()
        } else {
            displayLoadingDialog()
            let sr = SearchRequest()
            sr.sortBy = "name"
            sr.sortOrder = "ASC"
            sr.id.append(UInt64(bottleId))
            sr.allowSoldOut = 1
            Api.searchBottles(request: sr) { (res) in
                if (!res!.results!.isEmpty) {
                    self.bottle = res!.results![0]
                    self.getStores()
                } else {
                    sr.deliveryCountry.removeAll()
                    Api.searchBottles(request: sr) { (res) in
                        if (!res!.results!.isEmpty) {
                            self.bottle = res!.results![0]
                            self.getStores()
                            let alertController = UIAlertController(title: "Alert", message: "We could not find any store which deliver to your chosen delivery country.", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in}
                            alertController.addAction(action1)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            self.displayDialog(message: "This bottle has sold out", imageName: "albert_sad", duration: 2, complition: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                    }
                }
            }

        }
        
        imageGallery.layer.cornerRadius = imageGallery.frame.size.width / 2
        imageGallery.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 40
        if scrollView.contentOffset.y <= sectionHeaderHeight &&
            scrollView.contentOffset.y >= 0 {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
    
    func getStores() {
        setGallery()
        displayLoadingDialog()
        Api.getStores(for: bottle!.id) { (stores) in
            self.hideLoadingDialog()
            self.stores = stores!
            self.fillViews()
        }
    }
    
    func setGallery() {
        imageGallery.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        imageGallery.layer.borderWidth = 2
        imageGallery.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        imageGallery.delegate = self
        imageGallery.dataSource = self
    }
    
    func fillViews() {
        wishListButton.isSelected = FavoritesUtils.isFavorite(bottleId: bottle!.id)
        collectionBottle.isSelected = MyCollecyionUtils.isCollected(bottleId: bottle!.id)
            
        favIconTapped()
        collectionIconTapped()
        
        bottleIntoTableView.register(UINib(nibName: "BottleInfoTableViewCell",
                                           bundle: nil),
                                     forCellReuseIdentifier: "bottleInfoItem")
        bottleIntoTableView.register(UINib(nibName: "StoresTableViewCell",
                                           bundle: nil),
                                     forCellReuseIdentifier: "storesTableViewCell")
        
        initBottleInfo()
        bottleIntoTableView.dataSource = self
        bottleIntoTableView.delegate = self
        bottleIntoTableView.allowsSelection = false
        bottleIntoTableView.tableFooterView = UIView(frame: .zero)
        bottleIntoTableView.reloadData()
        UIView.transition(with: bottleIntoTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.bottleIntoTableView.isHidden = false
        })
        
        title = bottle!.name
        if let style = bottle!.style {
            if !style.isEmpty {
                bottleStyle.text = style
            } else {
                bottleStyle.text = ""
            }
        } else {
            bottleStyle.text = ""
        }
    }
    
    private func initBottleInfo() {
        infoData.append([("", "")]) // Stores Header
        var section1 = [(String, String)]()
        
        addItemToList(list: &section1, title: "Brand", value: bottle!.distillery)
        addItemToList(list: &section1, title: "Country", value: bottle!.country)
        addItemToList(list: &section1, title: "Region", value: bottle!.region)
        addItemToList(list: &section1, title: "Bottler", value: bottle!.bottler)
        addItemToList(list: &section1, title: "Series", value: bottle!.series)
        infoData.append(section1)
        
        var section2 = [(String, String)]()
        
        section2.append(("Age", (bottle!.age > 0) ? String(bottle!.age) : "NAS"))
        addItemToList(list: &section2, title: "Vintage", value: bottle!.vintage)
        if (bottle?.bottlingDate != nil) {
            section2.append(("Bottling Year", "\(bottle!.bottlingDate!)"))
        } else { section2.append(("Bottling Year", "-")) }
        addItemToList(list: &section2, title: "Abv", value: bottle!.abv)
        addItemToList(list: &section2, title: "Size", value: bottle!.size?.replacingOccurrences(of: ".", with: ""))
        infoData.append(section2)
        
        var section3 = [(String, String)]()
        addItemToList(list: &section3, title: "Cask Type", value: bottle!.caskType)
        addItemToList(list: &section3, title: "Cask Number", value: bottle!.caskNumber)
//        addItemToList(list: &section3, title: "Cask Refill", value: bottle!.cas)
//        addItemToList(list: &section3, title: "Cask Size", value: bottle!.caskSize)
        infoData.append(section3)

    }
    
    private func addItemToList(list: inout [(String, String)], title: String, value: String?) {
        if let val = value {
            list.append((title, val))
        } else {
            list.append((title, "-"))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottle!.imageUrl!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageGallery.dequeueReusableCell(withReuseIdentifier: "imageCell",
                                                    for: indexPath) as! ImageCollectionViewCell
        
        cell.bind(bottleId: bottle!.id, imageUrl: bottle!.imageUrl![indexPath.row])
        cell.image.backgroundColor = UIColor.white

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = bottle!.imageUrl!.count > 1 ? imageGallery.layer.bounds.size.width * 0.66 :imageGallery.layer.bounds.size.width
        return imageGallery.layer.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "slideshow", sender: indexPath.item)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return infoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0 && indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "storesTableViewCell",
                                                     for: indexPath) as! StoresTableViewCell
            
            cell.bind(stores: stores!)
            cell.delegate = self
            cell.bottleId = bottle!.id
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottleInfoItem",
                                                     for: indexPath) as! BottleInfoTableViewCell
            
            let tuple = infoData[indexPath.section][indexPath.row]
            cell.bind(title: tuple.0, value: tuple.1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section > 0) {
            return " "
        } else {
            return nil
        }
//        switch section {
//        case 0:
//            return "Get it from" + (stores!.count() > 1 ? " (\(stores!.count()) stores)" : "")
//        case 1:
//            return "Bottle"
//        case 2:
//            return "Cask"
//        default:
//            return " "
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160.0
        default:
            return 38.0
        }
    }
    
    func openStoreUrl(urlToOpen: String) {
        self.performSegue(withIdentifier: "openWeb", sender: urlToOpen)
    }
    
    func viewMoreStores() {
        performSegue(withIdentifier: "moreStores", sender: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        // text to share
        let link =  "https://www.thespiritthief.com/bottle/\(bottle!.id)"
        let message = "Hey! I found a bottle you might be interested in: \(link)"
        
        // set up activity view controller
        let textToShare = [ message ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        AnalyticsManager.bottleShared(bottleId: bottle!.id)
    }
    
    @IBAction func addToWishList(_ sender: Any) {
        FavoritesUtils.addOrRemove(bottleId: bottle!.id)
        wishListButton.isSelected = !wishListButton.isSelected
        favIconTapped()
    }
    
    @IBAction func addToMyCollection(_ sender: Any) {
        let added = MyCollecyionUtils.addOrRemove(bottleId: bottle!.id)
        collectionBottle.isSelected = !collectionBottle.isSelected
        collectionIconTapped()
        
        if added {
            if let barcode = bottle?.barcode {
                if (barcode.count == 0) {
                    displayBarcodeDialog()
                }
            } else {
                displayBarcodeDialog()
            }
        }
    }
    
    private func displayBarcodeDialog() {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "barcodeAlertViewController") as! BarcodeAlertViewController
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
        AnalyticsManager.scanBarcodeDialogDisplayed(bottleId: bottle!.id)
    }
    
    func favIconTapped(){
        if !wishListButton.isSelected {
            wishListButton.tintColor = UIColor(hexString: "#7a7a7a")
            wishListButton.setImage(UIImage(named : "favorite_unselected")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        } else {
            wishListButton.setImage(UIImage(named : "favorite_selected"), for: UIControlState.normal)
        }
    }
    
    func collectionIconTapped(){
        if !collectionBottle.isSelected {
            collectionBottle.setImage(UIImage(named : "collection"), for: UIControlState.normal)
        } else {
            collectionBottle.setImage(UIImage(named : "collected"), for: UIControlState.normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openWeb") {
            (segue.destination as! WebViewController).storeUrl = sender as! String
        } else if (segue.identifier == "slideshow") {
            let vc = segue.destination as! SlideshowViewController
            vc.urls = bottle!.imageUrl!
            vc.bottleId = bottle!.id
            vc.startPosition = sender as! Int
        } else if (segue.identifier == "moreStores") {
            let vc = segue.destination as! MoreStoresTableViewController
            vc.sortedStores = stores!
        } else if (segue.identifier == "scanBarcode") {
            let vc = segue.destination as! BarcodeScannerViewController
            vc.delegate = {(barcode) in
                if barcode.count > 0 {
                    self.bottle?.barcode = barcode
                    AnalyticsManager.userScanedBarcode(bottleId: self.bottle!.id, barcode: barcode)
                    Api.addBarcode(bottleId: String(self.bottle!.id), barcode: barcode, callback: { (success) in
                        if success {
                            self.displayDialog(message: "Thank You!", imageName: "thank")
                        }
                    })
                }
            }
        }
    }
    
    func barcodeAlertView(_ alertView: BarcodeAlertViewController, scan: Bool) {
        AnalyticsManager.scanBarcodeDialogUserAction(bottleId: bottle!.id, agreed: scan)
        alertView.dismiss(animated: !scan, completion: nil)
        if (scan) {
            performSegue(withIdentifier: "scanBarcode", sender: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
