//
//  SlideshowViewController.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 20/08/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class SlideshowViewController: UIViewController, UIScrollViewDelegate {
    var startPosition = 0
    var bottleId: UInt64 = 0
    var urls = [String]()
    var slides = [Slide]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pager: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for url in urls {
            let slide: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.url = url
            slide.bottleId = bottleId
            slides.append(slide)
        }
        
        scrollView.delegate = self
        setupSlideScrollView()
        pager.numberOfPages = slides.count
        pager.currentPage = startPosition
        scrollView.contentOffset.x = CGFloat((Int(view.frame.width) * startPosition))
        view.bringSubview(toFront: pager)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView()
    }
    
    func setupSlideScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pager.currentPage = Int(pageIndex)
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
