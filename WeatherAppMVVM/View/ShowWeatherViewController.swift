//
//  ShowWeatherViewController.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class ShowWeatherViewController: UIViewController {
    @IBOutlet weak var tempLbl:UILabel!
    @IBOutlet weak var locationLbl:UILabel!
    @IBOutlet weak var weatherIndicator:UIImageView!
    @IBOutlet weak var tempSwitchSegCont:UISegmentedControl!
    var zip:String?
    var firstTime:Bool = true
    var weatherAPI:WeatherAPI = WeatherAPI()
    var tempInKelvin:Double?
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if !firstTime{
            let returnedZip:String = weatherAPI.getFromCoreData()
            zip = returnedZip
        }
        guard let zipCode = zip else {return}
        let sv = UIViewController.displaySpinner(onView: self.view)
        weatherAPI.getWeather(apiURL: Constants.zipAPI+zipCode+Constants.countryCode+Constants.apiKey, complete: {
            (zipWeather, error) in
            UIViewController.removeSpinner(spinner: sv)
            DispatchQueue.main.async {
                guard let zipWeather = zipWeather else {return}
                self.tempInKelvin = zipWeather.main?.temp?.roundToDecimal(2)
                self.setupShowWeather(weather: zipWeather)
            }
        })
        startTimer()

    }
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupShowWeather(weather: ZipCodeWeather){
        var tempFarenheit:Double?
        if let checkTemp = weather.main?.temp{
            tempFarenheit = (checkTemp * 1.8) - 459.67
        }
        tempLbl.text = "\(tempFarenheit?.roundToDecimal(2) ?? 0.0) °F"
        locationLbl.text = "\(weather.name ?? ""), USA"
        weatherAPI.saveToCoreData(zip: zip ?? "")
        guard let weatherIcon = weather.weather?[0].icon else {return}
        weatherIndicator.imageFrom(url: Constants.weatherImageUrl+weatherIcon+".png")
    }
    @IBAction func tempSwitchSelected(_ sender:UISegmentedControl){
        guard let tempVal = tempInKelvin else {return}
        switch sender.selectedSegmentIndex {
        case 0:
            //C
            let celsiusVal = tempVal.roundToDecimal(2) - 273.15
            tempLbl.text = "\(celsiusVal.roundToDecimal(2)) °C"
        case 1:
            //F
            let farenheitVal = (tempVal.roundToDecimal(2) * 1.8) - 459.67
            tempLbl.text = "\(farenheitVal.roundToDecimal(2)) °F"
        default:
            print("Should not reach here!")
            break
        }
        //Kelvin to Celsius
        //API value - 273.15
        //Ex: Akron: 279.93 - 273.15 = 6.78 C
        
        //Kelvin to Farenheit
        //(API Value * (9/5)) - 459.67
        //Ex: Akron: (279.93 * (1.8)) - 459.67 = 503.874 - 459.67 = 44.204 F
    }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(checkWeather), userInfo: nil, repeats: true)
    }
    @objc func checkWeather(){
        let date = Date()
        print("TIMER WENT OFF... RECHECKING THE WEATHER! \(date)")
        guard let zipCode = zip else {return}
        weatherAPI.getWeather(apiURL: Constants.zipAPI+zipCode+Constants.countryCode+Constants.apiKey, complete: {
            (zipWeather, error) in
            DispatchQueue.main.async {
                guard let zipWeather = zipWeather else {return}
                self.tempInKelvin = zipWeather.main?.temp?.roundToDecimal(2)
                self.setupShowWeather(weather: zipWeather)
            }
        })
    }
}
