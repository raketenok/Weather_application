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
    let locationManager : CLLocationManager = CLLocationManager()
    
    
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
    
    var time1Text: String!
    var time2Text: String!
    var time3Text: String!
    var time4Text: String!
    
    var temp1Text: String!
    var temp2Text: String!
    var temp3Text: String!
    var temp4Text: String!
    
    var icon1Image: UIImage!
    var icon2Image: UIImage!
    var icon3Image: UIImage!
    var icon4Image: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Current", style:UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        //set setup
        
        self.openWeather.delegate = self
        
        locationManager.delegate = self
        
        //точность определение локации (точность зависит от расхода батареи)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //метод для разрешения локации только при использовании приложения
        locationManager.requestWhenInUseAuthorization()
       
        //следит за приложением и в фоновом режиме
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
    
        
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
    


    func activityIndicator(){
       
        hud.label.text = "Loading..."
        self.view.addSubview(hud)
        hud.showAnimated(true)
    }
    
//MARK: OpenWeatherMapDelegate
    
    func updateWeatherInfo(weatherJson: JSON) {
       
        hud.hideAnimated(true)
        
        
        if let tempResult = weatherJson["list"][0]["main"]["temp"].double {
            //get country
            
            let country = weatherJson["city"]["country"].stringValue
            
           //get city name
            
            let cityName = weatherJson["city"]["name"].stringValue
            print(cityName)
            self.cityNameLabel?.text = "\(cityName),\(country)"
            
            //get time
            
            let now = Int(NSDate().timeIntervalSince1970)
         
            // let time = weatherJson["dt"].int
            let timeToStr = openWeather.timeFromUnix(now)
            self.timeLabel?.text = "At \(timeToStr) it is"
            
            
            //get convert temperature
            
            let temperature = openWeather.convertTemperature(country, temperature: tempResult)
            self.tempLabel?.text = "\(temperature)"
            print(temperature)
            
            
            //get icon
            let weather = weatherJson["list"][0]["weather"][0]
            let condition = weather["id"].intValue
            let iconString = weather["icon"].stringValue
            let nightTime = openWeather.isTimeNight(iconString)
            let icon = openWeather.updateWeatherIcon(condition, nightTime: nightTime)
            self.iconImageView?.image = icon
        
            //get wind speed
            let speedWind = weatherJson["list"][0]["wind"]["speed"].doubleValue
            self.speedWindLabel?.text = "\(speedWind)"
            
            //get humidity
            let humidity = weatherJson["list"][0]["main"]["humidity"].intValue
            self.humidityLabel?.text = "\(humidity)"
            
            //get description
            
            let descript = weather["description"].stringValue
            self.descriptionLabel?.text = "\(descript)"
            let backgroundImage = openWeather.setBackground(condition, description: descript)
            self.view.backgroundColor = UIColor(patternImage: backgroundImage)
            
                    for index in 1...4 {
                        if let tempResult = weatherJson["list"][index]["main"]["temp"].double{
            
                            //convert temp
                            let temperature = openWeather.convertTemperature(country, temperature: tempResult)
            
                            //time
                            let time = weatherJson["list"][index]["dt"].int
                            let timeToStr = openWeather.timeFromUnix(time!)
                            //         self.timeLabel.text = "At \(timeToStr) it is"
            
                            //icon
                            let weather = weatherJson["list"][index]["weather"][0]
                            let condition = weather["id"].intValue
                            let iconString = weather["icon"].stringValue
                            let nightTime = openWeather.isTimeNight(iconString)
                            let icon = openWeather.updateWeatherIcon(condition, nightTime: nightTime)
            
                            if index == 1 {
            
                                time1Text =  "\(timeToStr)"
                                temp1Text = "\(temperature)"
                                icon1Image = icon
            
                            } else if index == 2 {
            
                                time2Text =  "\(timeToStr)"
                                temp2Text = "\(temperature)"
                                icon2Image = icon
            
                            } else if index == 3 {
            
                                time3Text =  "\(timeToStr)"
                                temp3Text = "\(temperature)"
                                icon3Image = icon
                            }else if index == 4 {
                                
                                time4Text =  "\(timeToStr)"
                                temp4Text = "\(temperature)"
                                icon4Image = icon
                                
                            }
                        }
                    }
        } else {
            print("Unable load weather info")
        }

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
    
 //MARK: Prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMore" {
            let forecastController = segue.destinationViewController as! ForecastViewController
            
            forecastController.temp1 = temp1Text
            forecastController.temp2 = temp2Text
            forecastController.temp3 = temp3Text
            forecastController.temp4 = temp4Text
            
            forecastController.time1 = time1Text
            forecastController.time2 = time2Text
            forecastController.time3 = time3Text
            forecastController.time4 = time4Text
            
            forecastController.icon1 = icon1Image
            forecastController.icon2 = icon2Image
            forecastController.icon3 = icon3Image
            forecastController.icon4 = icon4Image
          
        }
    }
    
}

