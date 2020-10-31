//
//  FavoritesViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 03/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    var bottles: [Bottle]? = nil
    var ids: [UInt64] = [UInt64]()
    var errorMessage: UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BottleListItem",
                                        bundle: nil),
                                  forCellReuseIdentifier: "bottleListItem")
        tableView.rowHeight = 144.0
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        let newIds = FavoritesUtils.getFavoriteBottlesIds().favorites
        if (newIds != ids) {
            ids = newIds
            fetchBottles()
        } else if (ids.count == 0) {
            showErrorMessage()
        }
    }
    
    func fetchBottles() {
        errorMessage?.removeFromSuperview()
    
        bottles = [Bottle]()
        tableView?.reloadData()
        let sr = SearchRequest()
        sr.sortBy = "name"
        sr.id = ids
        sr.allowSoldOut = 1
        
        if (sr.id.isEmpty) {
            showErrorMessage()
            bottles = nil
            self.tableView.reloadData()
        } else {
            Api.searchBottles(request: sr) { (response) in
                self.hideLoadingDialog()
                self.bottles = response?.results
                self.tableView.reloadData()
            }
        }
    }
    
    func showErrorMessage() {
        errorMessage = UILabel(frame: CGRect(x: view.frame.width * 0.05,
                                             y: 0,
                                             width: view.frame.width * 0.90,
                                             height: view.frame.height - tabBarController!.tabBar.frame.height))
        errorMessage!.numberOfLines = 0
        errorMessage!.text = "Your Wish List is currently empty.\nSearch for bottles and add them to your Wish List!"
        errorMessage!.textAlignment = .center
        view.addSubview(errorMessage!)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bottleListItem",
                                                 for: indexPath) as! BottleListItem
        cell.bind(bottle: bottles![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bottles != nil ? bottles!.count : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewBottle", sender: bottles?[indexPath.row])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewBottleTwo
        vc.bottle = sender as? Bottle
        tabBarController?.tabBar.isHidden = true
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
