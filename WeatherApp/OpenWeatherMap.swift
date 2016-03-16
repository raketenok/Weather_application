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
            
            if resp.result.error != nil {
                print("Error : \(resp.result.error)")
                
                self.delegate.failure()
            } else {
            
            let weatherJson = JSON(resp.result.value!)


            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate.updateWeatherInfo(weatherJson)
            })
                
            }
            
        }

        
    }
    
   
    func timeFromUnix(unixTime: Int) -> String {
        let timeInSecond = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSecond)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
  
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
    
    
    func convertTemperature (country: String, temperature : Double) -> Double {
        if (country == "US"){
            //convert to F
            return round(((temperature - 273.15) * 1.8) + 32)
        } else {
            //convert to C
            return round(temperature - 273.15)
        }
    }
    
    func setBackground (condition: Int, description: String) -> UIImage {
        
        // change background image
        
        
        var descript : String
        switch (condition, description){
            
            //Thunderstorm
        case let (x,_) where x < 300 : descript = "storm"
            
            //Drizzle
        case let (x,_) where x < 500 : descript = "drizzle"
            
            //Rain
        case let (x,_) where x < 600 : descript = "rain"
            
            //snow
        case let (x,_) where x < 700 : descript = "snow"
            
            //Atmosphere
        case let (x,_) where x < 800 : descript = "mist"
            
            //clouds
        case let (x,_) where x == 800 : descript = "sunnyDay"
            
        case let (x,_) where x < 900 : descript = "clouds"
        
       
        default: descript = "weather"
            
        }
        let weatherImageBackground = UIImage(named: descript)
        return weatherImageBackground!
    }
   }
