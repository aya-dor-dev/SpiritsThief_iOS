//
//  CollectionViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 16/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

fileprivate var numberOfColumns = 3
fileprivate var cellPadding: CGFloat = 6

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var errorMessage: UILabel? = nil
    var bottles: [Bottle]? = [Bottle]()
    var ids: [UInt64] = [UInt64]()
    var cardSize = CGSize(width: 0, height: 0);
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = self.collectionView!.layer.bounds.width
        let cardWidth = (screenWidth - 14)/3
        cardSize = CGSize(width: cardWidth, height: 175);
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CollectionViewBottleCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewBottleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        let newIds = MyCollecyionUtils.getCollectionBottlesIds().collected
        if (newIds != ids) {
            ids = newIds
            fetchBottles()
        } else if (newIds.count == 0) {
            showErrorMessage()
        }
    }

    func fetchBottles() {
        bottles = [Bottle]()
        collectionView?.reloadData()
        let sr = SearchRequest()
        sr.sortBy = "name"
        sr.id = ids
        sr.allowSoldOut = 1
        
        errorMessage?.removeFromSuperview()
        
        if (sr.id.isEmpty) {
            showErrorMessage()
            bottles = nil
            self.collectionView!.reloadData()
        } else {
            errorMessage?.removeFromSuperview()
            //            SVProgressHUD.show()
            view!.displayLoadingInView()
            Api.searchBottles(request: sr) { (response) in
                //                SVProgressHUD.dismiss()
                self.view!.hideLoadingInView()
                self.bottles = response?.results
                self.collectionView!.reloadData()
            }
        }
    }
    
    func showErrorMessage() {
        errorMessage = UILabel(frame: CGRect(x: view.frame.width * 0.05,
                                            y: 0,
                                            width: view.frame.width * 0.90,
                                            height: view.frame.height - tabBarController!.tabBar.frame.height))
        errorMessage!.numberOfLines = 0
        errorMessage!.text = "Your Collection is currently empty.\nSearch for bottles and add them to your Collection!"
        errorMessage!.textAlignment = .center
        view.addSubview(errorMessage!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return bottles != nil ? bottles!.count : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewBottleCell", for: indexPath) as! CollectionViewBottleCell
    
        cell.bind(bottle: bottles![indexPath.row])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cardSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewBottle", sender: bottles?[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewBottle") {
            navigationItem.backBarButtonItem = nil
            let vc = segue.destination as! ViewBottleTwo
            if let bottle = sender as? Bottle {
                vc.bottle = bottle
            } else if let bottleId = sender as? Int {
                vc.bottleId = bottleId
            }
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
