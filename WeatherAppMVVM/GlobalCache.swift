//
//  GlobalCache.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class GlobalCache{
    static let shared = GlobalCache()
    let imageCache = NSCache<NSString, UIImage>()
}
