//
//  LoadingView.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/10/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var contentView: LoadingView!
    @IBOutlet weak var loadingView: UIImageView!

    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set(v) {
            super.isHidden = v
          
            if (loadingView != nil && !v) {
                loadingView.spin(duration: 0.75)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
            
        loadingView.spin(duration: 0.75)
    }
}
