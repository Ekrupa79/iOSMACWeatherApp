//
//  Constants.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

//API Calls, zipAPI for addres, substitute for ZipCode, then add countryCode at end
class Constants{
    static let zipAPI = "https://api.openweathermap.org/data/2.5/weather?zip="
    static let apiKey = "&APPID=d6f224a24d3bdd2bb0f8f65ac19a75ec"
    static let countryCode = ",us"
    static let weatherImageUrl = "https://openweathermap.org/img/w/"
    
    //Use for testing
    static let testZip = "https://api.openweathermap.org/data/2.5/weather?zip=44333,us&APPID=d6f224a24d3bdd2bb0f8f65ac19a75ec"
}
