//
//  OnBoardingViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 28/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "OnBoardingChooseCountry"),
            self.getViewController(withIdentifier: "OnBoardingChooseCurrency"),
            self.getViewController(withIdentifier: "OnBoardingProductAvailability")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = nil
        self.delegate   = self
        
        if let firstVC = pages.first {
            (firstVC as! ChooseCountryViewController).delegate = {(country) in
                AnalyticsManager.setDeliveryCountry(country: country)
                UserDefaults.standard.set(country, forKey: Constants.PREF_COUNTRY)
                self.goToChooseCurrency()
            }
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goToChooseCurrency() {
        let secondPage = self.pages[1] as! OnBoardingChoosCurrencyiewController
        secondPage.delegate = {(currency) in
            UserDefaults.standard.set(currency, forKey: Constants.PREF_CURRENCY)
            AnalyticsManager.setCurrency(country: currency)
            self.goToProductAvailability()
        }
        self.setViewControllers([secondPage], direction: .forward, animated: true, completion: nil)
    }
    
    func goToProductAvailability() {
        let secondPage = self.pages[2] as! OnBoardingProductAvailability
        secondPage.delegate = {(empty) in
            self.goToApp()
        }
        self.setViewControllers([secondPage], direction: .forward, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return pages.last }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
    
    func goToApp() {
        performSegue(withIdentifier: "startApp", sender: self)
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
