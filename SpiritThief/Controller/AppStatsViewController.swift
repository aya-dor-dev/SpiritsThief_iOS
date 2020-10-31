//
//  AppStatsViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 25/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class AppStatsViewController: UIViewController {

    var stats: Stats? = nil
    
    @IBOutlet weak var bottlersImageView: UIImageView!
    @IBOutlet weak var brandsImageView: UIImageView!
    @IBOutlet weak var storesImageView: UIImageView!
    @IBOutlet weak var bottlesImageView: UIImageView!
    @IBOutlet weak var linksImageView: UIImageView!
    @IBOutlet weak var bottlersCountLable: UILabel!
    @IBOutlet weak var brandsCountLable: UILabel!
    @IBOutlet weak var storesCountLable: UILabel!
    @IBOutlet weak var bottlesCountLable: UILabel!
    @IBOutlet weak var linksCountLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tintImage(brandsImageView)
        tintImage(bottlesImageView)
        tintImage(bottlersImageView)
        tintImage(storesImageView)
        tintImage(linksImageView)
        
        bottlersCountLable.text = String(stats!.bottlers)
        brandsCountLable.text = String(stats!.brands)
        bottlesCountLable.text = String(stats!.products)
        storesCountLable.text = stats!.stores
        linksCountLable.text = String(stats!.links)
        
        roundLable(lable: bottlesCountLable)
        roundLable(lable: brandsCountLable)
        roundLable(lable: storesCountLable)
        roundLable(lable: bottlersCountLable)
        roundLable(lable: linksCountLable)
        
        
    }
    
    func tintImage(_ imageView: UIImageView) {
//        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor.white
    }
    
    func roundLable(lable: UILabel) {
        lable.layer.cornerRadius = 10
        lable.clipsToBounds = true
        lable.layer.borderWidth = 2
        lable.backgroundColor = UIColor(hexString: "#596275")
        lable.layer.borderColor = UIColor(hexString: "#ffffff").cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
