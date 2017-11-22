//
//  WeatherAPI.swift
//  WeatherAppMVVM
//
//  Created by Mac on 11/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import CoreData

class WeatherAPI{
    var zipCodes:[NSManagedObject] = []
    
    enum NetworkError:Error{
        case BadURL
        case NoDataOnServer
        case DataContainedNoImage
    }
    func getWeather(apiURL: String, complete: @escaping (ZipCodeWeather?, Error?) -> ()){
        guard let url = URL(string: apiURL) else {return}
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard error == nil, let data = data else {return}
            do{
                let zipWeather = try JSONDecoder().decode(ZipCodeWeather.self, from: data)
                complete(zipWeather,nil)
            }catch{
                print("Error in Network call: \(error.localizedDescription)")
                complete(nil, error)
            }
        }.resume()
    }
    func saveToCoreData(zip: String){
        if !checkForZip(zip: zip){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext

            guard let zipCode = NSEntityDescription.entity(forEntityName: "ZipCodes", in: managedContext) else {return}
            let zipCodeValue = NSManagedObject(entity: zipCode, insertInto: managedContext)
            zipCodeValue.setValue(zip, forKey: "zip")

            do{
                try managedContext.save()
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    func getFromCoreData() -> String{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName:"ZipCodes")
        
        do{
            zipCodes = try managedContext.fetch(request)
        }catch let error{
            print(error.localizedDescription)
        }
        guard let retVal = zipCodes[zipCodes.count-1].value(forKey: "zip") as? String else {return ""}
        return retVal
    }
    func checkForZip(zip: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName:"ZipCodes")
        
        do{
            zipCodes = try managedContext.fetch(request)
            for zc in zipCodes{
                guard let tryZip = zc.value(forKey: "zip") as? String else {return false}
                if tryZip == zip{
                    return true
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        return false
    }
    func checkForCoreData() -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName:"ZipCodes")
        
        do{
            let zipCount = try managedContext.fetch(request)
            if zipCount.count > 0 { return true }
        }catch let error{
            print(error.localizedDescription)
        }
        return false
    }
    class func getImage(from url:String, completionHandler:@escaping(UIImage?, Error?) -> ()){
        guard let url = URL(string:url) else {
            completionHandler(nil, NetworkError.BadURL)
            return
        }
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                completionHandler(nil, NetworkError.NoDataOnServer)
                return
            }
            guard let image = UIImage(data: data) else {
                completionHandler(nil, NetworkError.DataContainedNoImage)
                return
            }
            completionHandler(image, nil)
        }.resume()
    }
}
