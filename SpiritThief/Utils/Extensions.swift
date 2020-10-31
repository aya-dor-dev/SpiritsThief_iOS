//
//  Extensions.swift
//  SpiritThief
//
//  Created by Dor Ayalon on 24/07/2018.
//  Copyright © 2018 Spirit Thief. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UISearchBar {
    var textField:UITextField {
        guard let txtField = self.value(forKey: "_searchField") as? UITextField else {
            assertionFailure()
            return UITextField()
        }
        return txtField
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"
    
    func spin(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopSpinning() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    static func instantiateFromNib() -> Self? {
        
        func instanceFromNib<T: UIView>() -> T? {
            
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
        }
        
        return instanceFromNib()
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

extension UIViewController {
    
    func displayLoadingDialog() {
        hideLoadingDialog()
        let rect = view!.bounds
        let overlay = UIView(frame: rect)
        overlay.tag = 11311
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.isHidden = true
        let loadingView = LoadingView(frame: CGRect(origin: CGPoint(x: (overlay.bounds.width / 2) - 80,
                                                                    y: (overlay.bounds.height / 2) - 32), size: CGSize(width: 160, height: 64)))
        loadingView.contentView.layer.cornerRadius = 15
        overlay.addSubview(loadingView)
        
        view!.addSubview(overlay)
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            overlay.isHidden = false
        })
    }
    
    func hideLoadingDialog() {
        var dialog: UIView? = nil
        
        view!.subviews.forEach { (view) in
            if view.tag == 11311 {
                dialog = view
            }
        }
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            dialog?.isHidden = true
        }) { (finished) in
            dialog?.removeFromSuperview()
        }
    }
}

extension UIView {
    
    func displayLoadingInView() {
        if (getLoadingView() != nil) {
            return
        }
        
        let rect = CGRect(origin: CGPoint(x: (self.bounds.width / 2) - 80,
                                          y: (self.bounds.height / 2) - 32),
                          size: CGSize(width: 160, height: 64))
        
        let loadingView = LoadingView(frame: rect)
        loadingView.backgroundColor = nil
        loadingView.contentView.backgroundColor = nil
        loadingView.isHidden = true

        self.addSubview(loadingView)
//        loadingView.center = self.center
        
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            loadingView.isHidden = false
        })
    }
    
    func hideLoadingInView() {
        var loadingView = getLoadingView()
        
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            loadingView?.isHidden = true
        }) { (finished) in
            loadingView?.removeFromSuperview()
        }
    }
    
    func getLoadingView() -> LoadingView? {
        var lv: LoadingView? = nil
        self.subviews.forEach { (view) in
            if (view is LoadingView) {
                lv = view as! LoadingView
            }
        }
        
        return lv
    }
}

extension UIImage {
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
}

extension UIViewController {
    func displayDialog(message: String,
                       imageName: String,
                       duration: CGFloat? = 2,
                       complition: (() -> Void)? = nil) {
        let rect = view!.bounds
        let overlay = UIView(frame: rect)
        overlay.tag = 11312
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlay.isHidden = true
        
        let dialog = UIView(frame: CGRect(origin: CGPoint(x: (overlay.bounds.width / 2) - 100,
                                                          y: (overlay.bounds.height / 2) - 100),
                                          size: CGSize(width: 200, height: 100)))
        dialog.backgroundColor = UIColor.white
        dialog.layer.cornerRadius = 15
        dialog.clipsToBounds = true
        
        let label = UILabel(frame: dialog.bounds)
        label.text = message
        label.textAlignment = NSTextAlignment.center
        
        dialog.addSubview(label)
        
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: (overlay.bounds.width / 2) - 40,
                                                              y: (dialog.layer.position.y - 90)),
                                              size: CGSize(width: 80, height: 80)))
        image.backgroundColor = UIColor.white
        image.layer.cornerRadius = 40
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: imageName)?.imageWithInsets(insetDimen: 4)
    
        
        overlay.addSubview(dialog)
        overlay.addSubview(image)
        
        view!.addSubview(overlay)
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            overlay.isHidden = false
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                overlay.isHidden = true
            }, completion: { (success) in
                overlay.removeFromSuperview()
                complition?()
            })
        }
    }
}

extension UIImageView {
    func load(bottleId: UInt64, imageLink: String, placeHolder: UIImage? = nil) {
        var link = imageLink.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: link) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    } else {
                        self?.image = placeHolder
                        Api.repordInvalidImage(bottleId: String(bottleId), imageUrl: imageLink)
                    }
                } else {
                    self?.image = placeHolder
                    Api.repordInvalidImage(bottleId: String(bottleId), imageUrl: imageLink)
                }
            }
        }
    }
}

