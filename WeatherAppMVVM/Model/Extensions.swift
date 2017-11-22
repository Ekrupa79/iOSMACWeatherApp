//
//  Extensions.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

extension UIImageView{
    func imageFrom(url:String){
        let cache = GlobalCache.shared.imageCache
        if let image = cache.object(forKey: url as NSString){
            self.image = image
            return
        }
        WeatherAPI.getImage(from: url){
            (image,error) in
            guard error == nil else {return}
            guard let image = image else {return}
            cache.setObject(image, forKey: url as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
extension UIViewController{
    class func displaySpinner(onView: UIView) -> UIView{
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 192/255, green: 48/255, blue: 40/255, alpha: 0.7)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    class func removeSpinner(spinner: UIView){
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
extension Double{
    func roundToDecimal(_ decimals: Int) -> Double{
        let mult = pow(10, Double(decimals))
        return Darwin.round(self * mult) / mult
    }
}
