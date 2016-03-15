//
//  ShowMoreViewController.swift
//  WeatherApp
//
//  Created by Yevgen Yefimenko on 14.03.16.
//  Copyright © 2016 Yevgen Yefimenko. All rights reserved.
//

import UIKit




class ForecastViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    @IBOutlet weak var timeLabel4: UILabel!
    
    @IBOutlet weak var tempLabel1: UILabel!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var tempLabel3: UILabel!
    @IBOutlet weak var tempLabel4: UILabel!
    
    @IBOutlet weak var iconImage1: UIImageView!
    @IBOutlet weak var iconImage2: UIImageView!
    @IBOutlet weak var iconImage3: UIImageView!
    @IBOutlet weak var iconImage4: UIImageView!
    
    @IBOutlet weak var viewForecast: UIView!
    
    var time1: String!
    var time2: String!
    var time3: String!
    var time4: String!
    
    var temp1: String!
    var temp2: String!
    var temp3: String!
    var temp4: String!
    
    var icon1: UIImage!
    var icon2: UIImage!
    var icon3: UIImage!
    var icon4: UIImage!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let background = UIImage(named: "weather.png")
        self.view.backgroundColor = UIColor(patternImage: background!)
        self.viewForecast.backgroundColor = UIColor.whiteColor()
        

        
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translation = CGAffineTransformMakeTranslation(0.0, 200.0)
        viewForecast.transform = CGAffineTransformConcat(scale, translation)
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            let scale = CGAffineTransformMakeScale(1.0, 1.0)
            let translation = CGAffineTransformMakeTranslation(0.0, 0.0)
            self.viewForecast.transform = CGAffineTransformConcat(scale, translation)
            }, completion: nil)
        
        self.viewForecast.layer.cornerRadius = self.viewForecast.frame.size.width / 2
        self.viewForecast.clipsToBounds = true
        
        timeLabel1.text = time1
        timeLabel2.text = time2
        timeLabel3.text = time3
        timeLabel4.text = time4
        
        tempLabel1.text = temp1
        tempLabel2.text = temp2
        tempLabel3.text = temp3
        tempLabel4.text = temp4
        
        iconImage1.image = icon1
        iconImage2.image = icon2
        iconImage3.image = icon3
        iconImage4.image = icon4
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
