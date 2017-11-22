//
//  WeatherViewController.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var zipTB:UITextField!
    @IBOutlet weak var weatherBtn:UIButton!
    
    var firstTime:Bool = true
    var weatherValues:ZipCodeWeather?
    var weatherAPI:WeatherAPI = WeatherAPI()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.weatherAPI.checkForCoreData() {
            askForFirstTime()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getWeatherBtnPush(_ sender: AnyObject){
        guard let zipText = zipTB.text else {return}
        if !zipText.isEmpty && zipText.characters.count == 5{
            self.performSegue(withIdentifier: "ToShow", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showView = segue.destination as? ShowWeatherViewController{
            guard let zipText = zipTB.text else {return}
            showView.firstTime = firstTime
            showView.zip = zipText
        }
    }
    func askForFirstTime(){
        let alert = UIAlertController(title: "First time using the Weather App?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .cancel)
        let noAction = UIAlertAction(title: "NO", style: .default){
            (alert:UIAlertAction) in
            self.firstTime = false
            self.performSegue(withIdentifier: "ToShow", sender: nil)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}
