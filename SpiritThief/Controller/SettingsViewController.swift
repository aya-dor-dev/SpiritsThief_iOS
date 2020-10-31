//
//  SettingsViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 29/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    
    var countries = [String: String]()
    var choices = [String]()
    var pickerView = UIPickerView()
    var pickerTitle = ""
    var pickerSelectedItem = -1
    var pickerDelegate: (String) -> Void = {(_) in}
    
    var data = [(title: String, value: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableData()
        
        tableView.register(UINib(nibName: "SettingsTableViewCell",
                                           bundle: nil),
                                     forCellReuseIdentifier: "settingsTableViewCell")
        
        tableView.rowHeight = 44.0
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
//        let logo = UIImage(named: "logo")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
//        
    }
    
    func initTableData() {
        data.removeAll()
        data.append(("Delivery Country", UserSettings.getDeliveryCountryName()))
        data.append(("Currency", UserDefaults.standard.string(forKey: Constants.PREF_CURRENCY)!))
        data.append(("Statistics", ""))
        data.append(("Shop Stats", ""))
        data.append(("Contact Us", ""))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell") as! SettingsTableViewCell
        
        let rowData = data[indexPath.row]
        cell.title.text = rowData.title
        cell.value.text = rowData.value
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choices.removeAll()
        switch indexPath.row {
        case 0:
            openDeliveryCountryDialog()
            return
            break
        case 1:
            openCurrencyDialog()
//            pickerTitle = "Currency"
//            pickerDelegate = {(currency) in
//                AnalyticsManager.setCurrency(country: currency)
//                UserDefaults.standard.set(currency, forKey: Constants.PREF_CURRENCY)
//                self.initTableData()
//                self.tableView.reloadData()
//            }
//
//            let alert = UIAlertController(title: pickerTitle, message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
//            alert.isModalInPopover = true
//
//            pickerView = UIPickerView(frame: CGRect(x: 50, y: 20, width: 250, height: 140))
//
//            alert.view.addSubview(pickerView)
//            pickerView.dataSource = self
//            pickerView.delegate = self
//
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//                let selected = self.choices[self.pickerView.selectedRow(inComponent: 0)]
//                self.pickerDelegate(selected)
//            }))
//            alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
//            pickerView.selectRow(pickerSelectedItem, inComponent: 0, animated: false)
//            self.present(alert,animated: true, completion: nil )
            break
        case 2:
            displayLoadingDialog()
            let req = SearchRequest()
            req.setDeliveryCountry()
            Api.getStats() { (stats) in
                self.hideLoadingDialog()
                self.performSegue(withIdentifier: "appStats", sender: stats[0])
            }
            break
        case 3:
            displayLoadingDialog()
            let req = SearchRequest()
            req.setDeliveryCountry()
            Api.getShopStats() { (stats) in
                var statsData = [(title: String, count: Int, countryCode: String)]()
                for shopStat in stats {
                    statsData.append((shopStat.name, shopStat.links, shopStat.countryCode))
                }
                self.hideLoadingDialog()
                self.performSegue(withIdentifier: "openStats", sender: statsData)
            }
            break
        case 4:
            sendEmail()
            return
            break
        default:
            break
        }
    }
    
    private func openDeliveryCountryDialog() {
        let dataSource = DeliveryCountryDataSource()
        let alert = UIAlertController(title: "Delivery Country", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        pickerView = UIPickerView(frame: CGRect(x: 50, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerView)
        pickerView.dataSource = dataSource
        pickerView.delegate = dataSource
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let country = dataSource.getCountryCode(forRow: self.pickerView.selectedRow(inComponent: 0))
            AnalyticsManager.setDeliveryCountry(country: country)
            UserDefaults.standard.set(country, forKey: Constants.PREF_COUNTRY)
            self.initTableData()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
        pickerView.selectRow(pickerSelectedItem, inComponent: 0, animated: false)
        pickerView.selectRow(dataSource.countriesNames.firstIndex(of: UserSettings.getDeliveryCountryName())!, inComponent: 0, animated: false)
        
        self.present(alert,animated: true, completion: nil )
    }
    
    private func openCurrencyDialog() {
        let dataSource = CurrencyDataSource()
        let alert = UIAlertController(title: "Currency", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        
        pickerView = UIPickerView(frame: CGRect(x: 50, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerView)
        pickerView.dataSource = dataSource
        pickerView.delegate = dataSource
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            let currency = dataSource.choices[self.pickerView.selectedRow(inComponent: 0)]
            AnalyticsManager.setCurrency(country: currency)
            UserDefaults.standard.set(currency, forKey: Constants.PREF_CURRENCY)
            self.initTableData()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .destructive, handler: nil))
        pickerView.selectRow(dataSource.pickerSelectedItem, inComponent: 0, animated: false)
        
        self.present(alert,animated: true, completion: nil )
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@thespiritthief.com"])
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openStats") {
            let statsData = sender as! [(title: String, count: Int, countryCode: String)]
            let vc = segue.destination as! StatsTableViewController
            vc.title = "Shop Stats"
            vc.statsData = statsData
        } else if (segue.identifier == "appStats") {
            let stats = sender as! Stats
            let vc = segue.destination as! AppStatsViewController
            vc.stats = stats
        }
    }
}

//class DeliveryCountryPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
//    var options: ([DeliveryCountry], [DeliveryCountry])
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
//
//
//}
