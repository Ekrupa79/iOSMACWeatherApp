//
//  ZipCodeWeather.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

struct ZipCodeWeather:Codable{
    var coord:CoordPair?
    var weather:[Weather]?
    var base:String?
    var main:MainStats?
    var wind:WindStats?
    var clouds:CloudStats?
    var rain:RainStats?
    var snow:SnowStats?
    var dt:Int?
    var sys:SysStats?
    var id:Int?
    var name:String?
    var cod:Int?
}
struct CoordPair:Codable{
    var longitude:Double?
    var latitude:Double?
}
struct Weather:Codable{
    var id:Int?
    var main:String?
    var description:String?
    var icon:String?
}
struct MainStats:Codable{
    var temp:Double?
    var pressure:Int?
    var humidity:Int?
    var temp_min:Double?
    var temp_max:Double?
    var sea_level:Double?   //Check into later
    var grnd_level:Double?  //Check into later
}
struct WindStats:Codable{
    var speed:Double?
    var deg:Double?
}
struct CloudStats:Codable{
    var all:Int?
}
struct RainStats:Codable{
    var rVolume:Double?
}
struct SnowStats:Codable{
    var sVolume:Double?
}
struct SysStats:Codable{
    var type:Int?
    var id:Int?
    var message:Double?
    var country:String?
    var sunrise:Int?    //Unix, UTC
    var sunset:Int?     //Unix, UTC
}

