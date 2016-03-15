//
//  OpenWeatherMap.swift
//  WeatherApp
//
//  Created by Yevgen Yefimenko on 06.03.16.
//  Copyright © 2016 Yevgen Yefimenko. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation






protocol OpenWeatherMapDelegate {
    
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
    
}

//http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=44db6a862fba0b067b1930da0d769e98

class OpenWeatherMap {
    let weatherUrl = "http://api.openweathermap.org/data/2.5/forecast?&appid=f6a8f68b522cdbe281a79d23f2802c3c"
    var nameCity : String?
    var temp : Double?
    
    var description : String?
    
    var currentTime : String?
    var icon : UIImage?
    
    var delegate : OpenWeatherMapDelegate!
    
    func weatherFor(city: String){
    
        let params = ["q" : city]
        setRequest(params)
       
       }
    
    func weatherFor(geo: CLLocationCoordinate2D){
        //http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=44db6a862fba0b067b1930da0d769e98
        let params = ["lat" : geo.latitude, "lon" : geo.longitude]
        setRequest(params)
    }
    
    func setRequest(params: [String : AnyObject]?){
       
        request(Method.GET, weatherUrl, parameters: params).responseJSON { (resp) -> Void in
            debugPrint(resp)
            //       print(resp.request)
            //        print(resp.response)
            //        print (resp.data)
            //        print(resp.result)
            
            if resp.result.error != nil {
                print("Error : \(resp.result.error)")
                
                self.delegate.failure()
            } else {
            
            let weatherJson = JSON(resp.result.value!)
//            if let name = weatherJson["name"].string {
//                self.nameCity = name
//            }
//            if let temperature = weatherJson["main"]["temp"].double {
//                self.temp = temperature
//            }
//            if let descript = weatherJson["weather"][0]["description"].string {
//                self.description = descript
//            }
//            if let currentTime = weatherJson["dt"].int {
//                self.currentTime = self.timeFromUnix(currentTime)
//            }
//            if let iconString = weatherJson["weather"][0]["icon"].string {
//                self.icon = self.weatherIcon(iconString)
//            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate.updateWeatherInfo(weatherJson)
            })
                
            }
            
        }

        
    }
    
    
//    init(weatherJson : NSDictionary) {
//        
//        nameCity = weatherJson["name"] as! String
//        let main = weatherJson ["main"] as? NSDictionary
//        temp = main!["temp"] as! Int
//        let weather  = weatherJson["weather"] as! NSArray
//        let zero = weather[0] as! NSDictionary
//        description = zero["description"] as! String
//        
//        let dt = weatherJson["dt"] as! Int
//        currentTime = timeFromUnix(dt)
//        
//        let iconString = zero["icon"] as! String
//        icon = weatherIcon(iconString)
//    }
    
    
    
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
   /* func weatherIcon(stringIcon: String) -> UIImage{
        let imageName: String
        switch stringIcon{
            case "01d": imageName = "01d"
            case "02d": imageName = "02d"
            case "03d": imageName = "03d"
            case "04d": imageName = "04d"
            case "09d": imageName = "09d"
            case "10d": imageName = "10d"
            case "11d": imageName = "11d"
            case "13d": imageName = "13d"
            case "50d": imageName = "50d"
            case "01n": imageName = "01n"
            case "02n": imageName = "02n"
            case "03n": imageName = "03n"
            case "04n": imageName = "04n"
            case "09n": imageName = "09n"
            case "10n": imageName = "10n"
            case "11n": imageName = "11n"
            case "13n": imageName = "13n"
            case "50n": imageName = "50n"
        default: imageName = "none"
        }
        let iconImage = UIImage(named: imageName)
        return iconImage!
        
    }
 */
    func updateWeatherIcon(condition: Int, nightTime: Bool) -> UIImage {
        var imageName: String
        switch (condition, nightTime){
        //Thunderstorm
        case let (x,y) where x < 300 && y == true : imageName = "11n"
        case let (x,y) where x < 300 && y == false : imageName = "11d"
            //Drizzle
        case let (x,y) where x < 500 && y == true : imageName = "09n"
        case let (x,y) where x < 500 && y == false : imageName = "09d"
            //rain
        case let (x,y) where x <= 504 && y == true : imageName = "10n"
        case let (x,y) where x <= 504 && y == false : imageName = "10d"
            
        case let (x,y) where x == 511 && y == true : imageName = "13n"
        case let (x,y) where x == 511 && y == false : imageName = "13d"
            
        case let (x,y) where x < 600 && y == true : imageName = "09n"
        case let (x,y) where x < 600 && y == false : imageName = "09d"
            //snow
        case let (x,y) where x < 700 && y == true : imageName = "13n"
        case let (x,y) where x < 700 && y == false : imageName = "13d"
            //Atmosphere
        case let (x,y) where x < 800 && y == true : imageName = "50n"
        case let (x,y) where x < 800 && y == false : imageName = "50d"
            //clouds
        case let (x,y) where x == 800 && y == true : imageName = "01n"
        case let (x,y) where x == 800 && y == false : imageName = "01d"
        
        case let (x,y) where x == 801 && y == true : imageName = "02n"
        case let (x,y) where x == 801 && y == false : imageName = "02d"
            
        case let (x,y) where x > 802 || x < 804 && y == true : imageName = "03n"
        case let (x,y) where x > 802 || x < 804 && y == false : imageName = "03d"
    
        case let (x,y) where x == 804 && y == true : imageName = "04n"
        case let (x,y) where x == 804 && y == false : imageName = "04d"
            //additional
        case let (x,y) where x < 1000  && y == true : imageName = "11n"
        case let (x,y) where x < 1000  && y == false : imageName = "11d"
            
        default: imageName = "none"
            
        }
        let iconImage = UIImage(named: imageName)
        return iconImage!
    }
    
    func isTimeNight (icon : String) -> Bool {
        return icon.rangeOfString("n") != nil
    }
    
//    func isTimeNight (weatherJSON: JSON) -> Bool{
//        
//        var nightTime = false
//        
//        let nowTime = NSDate().timeIntervalSince1970
//        let sunrise = weatherJSON["sys"]["sunrise"].doubleValue
//        let sunset = weatherJSON["sys"]["sunset"].doubleValue
//        
//        if (nowTime < sunrise || nowTime > sunset ){
//            nightTime = true
//        }
//        return nightTime
//        
//    }
    
    
    func convertTemperature (country: String, temperature : Double) -> Double {
        if (country == "US"){
            //convert to F
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            //convert to C
            return round(temperature - 273.15)
        }
    }
    
    func setBackground (description: String) -> UIImage {
        
        // change background image
        
        var descript : String
        switch description{
        case let string where string == "clear sky" : descript = "sunnyDay"
        case let string where string == "few clouds" : descript = "fewClouds"
        case let string where string == "scattered clouds" : descript = "clouds"
        case let string where string == "broken clouds"   : descript = "clouds"
        case let string where string == "shower rain" : descript = "rain"
        case let string where string == "rain"  : descript = "rain"
        case let string where string == "thunderstorm" : descript = "storm"
        case let string where string == "snow" : descript = "snow"
        case let string where string == "mist" : descript = "mist"
        default: descript = "weather"
            
        }
        let weatherImageBackground = UIImage(named: descript)
        return weatherImageBackground!
    }
    
}
