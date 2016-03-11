//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yevgen Yefimenko on 06.03.16.
//  Copyright © 2016 Yevgen Yefimenko. All rights reserved.
//

import UIKit
import CoreLocation



class ViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    var openWeather = OpenWeatherMap()
    var hud = MBProgressHUD()
    let locationManager = CLLocationManager()
    
    
    @IBAction func buttonAction(sender: UIButton) {
        
        displayCity()
    }
    
    @IBAction func cityFindAction(sender: UIBarButtonItem) {
        
        
        displayCity()
        
    }
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background
        
        let background = UIImage(named: "background.png")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        
        
        
        //set setup
        
        self.openWeather.delegate = self
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
//        let stringURL = NSURL(string: url)
//        let weatherObject = NSData(contentsOfURL: stringURL!)
//        print(weatherObject)
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.downloadTaskWithURL(stringURL!) { (NSURL, NSURLResponse, NSError) -> Void in
//         //   print(NSURLResponse)
//            
//        let weatherData = NSData(contentsOfURL: stringURL!)
//        let weatherJson = try! NSJSONSerialization.JSONObjectWithData(weatherData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//            
//        let weather = OpenWeatherMap(weatherJson: weatherJson)
//            print(weather.nameCity)
//            print(weather.temp)
//            print(weather.description)
//            print(weather.currentTime!)
//            print(weather.icon)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                 self.iconImageView.image = weather.icon
//            })
//            
//           
//            
//        }
//        task.resume()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCity() {
        
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            if let textField = alert.textFields?.first as UITextField! {
//                self.getWeatherFor(textField.text!)
                self.activityIndicator()
                self.openWeather.weatherFor(textField.text!)
                
            }
        }
        alert.addAction(ok)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "City name"
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
//    func getWeatherFor(city: String) {
//        print(city)
//    }

    func activityIndicator(){
        hud.label.text = "Loading..."
//        hud.dimBackground = true

        self.view.addSubview(hud)
        hud.showAnimated(true)
    }
    
//MARK: OpenWeatherMapDelegate
    
    func updateWeatherInfo(weatherJson: JSON) {
       
        hud.hideAnimated(true)
        
        if let tempResult = weatherJson["main"]["temp"].double {
            //get country
            
            let country = weatherJson["sys"]["country"].stringValue
            
           //get city name
            
            let cityName = weatherJson["name"].stringValue
            print(cityName)
            self.cityNameLabel.text = "\(cityName),\(country)"
            
            //get time
            
            let time = weatherJson["dt"].int
            let timeToStr = openWeather.timeFromUnix(time!)
            self.timeLabel.text = "At \(timeToStr) it is"
            
            
            //get convert temperature
            
            let temperature = openWeather.convertTemperature(country, temperature: tempResult)
            self.tempLabel.text = "\(temperature)"
            print(temperature)
            
            
            //get icon
            let weather = weatherJson["weather"][0]
            let condition = weather["id"].intValue
            let nightTime = openWeather.isTimeNight(weatherJson)
            let icon = openWeather.updateWeatherIcon(condition, nightTime: nightTime)
            self.iconImageView.image = icon
            
            //get description
            let descript = weather["description"].stringValue
            self.descriptionLabel.text = "\(descript)"
            
            //get wind speed
            let speedWind = weatherJson["wind"]["speed"].doubleValue
            self.speedWindLabel.text = "\(speedWind)"
            
            //get humidity
            let humidity = weatherJson["main"]["humidity"].intValue
            self.humidityLabel.text = "\(humidity)"
            
            
        } else {
            print("Unable load weather info")
        }
//        print(openWeather.nameCity)
//        print(openWeather.temp)
//        print(openWeather.currentTime)
//        print(openWeather.icon)
//        print(openWeather.description)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.iconImageView.image = self.openWeather.icon
//        })
    }
    
    func failure() {
        //No connection internet
        let networkController = UIAlertController(title: "Error", message: "No conntection", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        networkController.addAction(okButton)
        self.presentViewController(networkController, animated: true, completion: nil)
        
    }
    
    
//MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location)
        self.activityIndicator()
        let currentLocation = locations.last as CLLocation!
        if (currentLocation.horizontalAccuracy > 0) {
            //stop update for saving battery
            locationManager.stopUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.openWeather.weatherFor(coords)
            print(coords)
        }
        

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        print("Can't get your location")
    }
    
}

