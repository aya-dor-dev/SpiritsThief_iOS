//
//  MoreStoresTableViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 03/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class MoreStoresTableViewController: UITableViewController {
    var sortedStores = SortedStores(stores: [Store]())
    var map = [(title: String, data: [Store])]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ShopTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "storeTableCell")
        tableView.rowHeight = 56.0
        if !sortedStores.verified.isEmpty {
            map.append((title: "Verified", data: sortedStores.verified))
        }
        if !sortedStores.unverified.isEmpty {
            map.append((title: "Unverified", data: sortedStores.unverified))
        }
        if !sortedStores.soldOut.isEmpty {
            map.append((title: "Sold Out", data: sortedStores.soldOut))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return map.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return map[section].data.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return map[section].title
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeTableCell", for: indexPath) as! ShopTableViewCell
        
        let store = map[indexPath.section].data[indexPath.row]
        cell.storeNameLabel.text = store.name!
        cell.storeFlagLabel.text = ImageUtils.getFlagEmoji(forCountryCode: store.countryCode)
        if let price = store.price, let currency = store.currency {
            cell.priceLable.text = currency + String(price).split(separator: ".")[0]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openWeb", sender: map[indexPath.section].data[indexPath.row].url)
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openWeb") {
            (segue.destination as! WebViewController).storeUrl = sender as! String
        }
    }
 

}
