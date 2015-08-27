//
//  ViewController.swift
//  Weather-iOS
//
//  Created by Simon Yang on 8/18/15.
//  Copyright (c) 2015 Simon Yang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let scroll = UIScrollView()
    let cityLabel = UILabel()
    let background = UIImageView()
    let temperatureLabel = UILabel()
    let temperatureLabelMax = UILabel()
    let temperatureLabelMin = UILabel()
    let phenomenonLabel = UILabel()

//    var location:String = "";
    
    var db:FMDatabase!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
        initLocationManager()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            
            var geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                if placemarks != nil && placemarks.count > 0 {
                    
                    var placemark = placemarks[0] as! CLPlacemark
//                    self.location = placemark.locality
                    self.getWeatherInfo(placemark.locality)

                } else {
                    println("Geocoder Error")
                    SVProgressHUD.dismiss()
                }
                
            })
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
    }
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func initView() {
        
        view.addSubview(scroll)
        
        initScrollView()
        initBackground()
        
        initTemperatureView()
        initCityLabel()
        
        makeConstraints()
    }
    
    func initScrollView() {
        scroll.frame = self.view.bounds
        scroll.bounces = true
        scroll.alwaysBounceVertical = true
            
        scroll.addSubview(background)
        scroll.addSubview(cityLabel)
        scroll.addSubview(temperatureLabel)
        scroll.addSubview(temperatureLabelMax)
        scroll.addSubview(temperatureLabelMin)
        scroll.addSubview(phenomenonLabel)

    }
    
    func initCityLabel() {
        cityLabel.textColor = UIColor.blackColor()
        cityLabel.font = UIFont(name: "HelveticaNeue", size: 30.0)
        cityLabel.textAlignment = NSTextAlignment.Center
    }
    
    func initTemperatureView() {

        var color = UIColor.blackColor()

        temperatureLabel.textColor = color
        temperatureLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 100.0)
        temperatureLabel.textAlignment = NSTextAlignment.Left

        temperatureLabelMax.textColor = color
        temperatureLabelMax.font = UIFont(name: "HelveticaNeue", size: 20)
        temperatureLabelMax.textAlignment = NSTextAlignment.Left

        temperatureLabelMin.textColor = color
        temperatureLabelMin.font = UIFont(name: "HelveticaNeue", size: 20)
        temperatureLabelMin.textAlignment = NSTextAlignment.Left

        phenomenonLabel.textColor = color
        phenomenonLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        phenomenonLabel.textAlignment = NSTextAlignment.Left


    }
    
    func makeConstraints() {
        scroll.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(view)
            make.size.equalTo(view)
        }
        
        cityLabel.snp_remakeConstraints { (make) -> Void in
            make.centerX.equalTo(scroll)
            make.top.equalTo(scroll.snp_top).offset(50)
        }
        
        temperatureLabel.snp_remakeConstraints { (make) -> Void in
            make.width.equalTo(scroll)
            make.left.equalTo(scroll).offset(30)
            make.bottom.equalTo(scroll).offset(-10)
        }

        temperatureLabelMax.snp_remakeConstraints { (make) -> Void in
            make.left.equalTo(scroll).offset(30)
            make.bottom.equalTo(temperatureLabel.snp_top).offset(10)
        }

        temperatureLabelMin.snp_remakeConstraints { (make) -> Void in
            make.left.equalTo(temperatureLabelMax.snp_right).offset(20)
            make.top.equalTo(temperatureLabelMax.snp_top)
        }

        phenomenonLabel.snp_remakeConstraints { (make) -> Void in
            make.width.equalTo(scroll)
            make.left.equalTo(scroll).offset(34)
            make.bottom.equalTo(temperatureLabelMax.snp_top).offset(-10)
        }

        
    }
    
    func initBackground() {
        
        background.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(scroll)
            make.size.equalTo(scroll)
        }
        
        self.background.contentMode = UIViewContentMode.ScaleAspectFill
        self.background.image = UIImage(named: "weather_bg")
        
    }
    
    func getWeatherInfo(locality : String) {
    
        Alamofire.request(.GET, HttpUtils.getRequest(locality))
            .responseJSON { (req, res, json, error) in
                
                if (error != nil) {
                    NSLog("Error: \(error)")
                   
                } else {
                    var json = JSON(json!)
                    println("The json is \(json)")
                    
                    let flist: Array<JSON>  = json["f"]["f1"].arrayValue
                    
                    for f in flist {
                        var temperatureMax : String = f["fc"].stringValue
                        var temperatureMin : String = f["fd"].stringValue
                        if temperatureMax.isEmpty || temperatureMin.isEmpty {
                            continue
                        }
                        
                        
                        self.temperatureLabel.text = "\(temperatureMax)°"
                        self.temperatureLabelMax.text = "↑ \(temperatureMax)°"
                        self.temperatureLabelMin.text = "↓ \(temperatureMin)°"
                        break
                        
                    }

                    for f in flist {

                        var phenomenonLabelDay : String = f["fa"].stringValue
                        var phenomenonLabelNight = f["fb"].stringValue

                        if phenomenonLabelDay.isEmpty && phenomenonLabelNight.isEmpty {
                            continue
                        }

                        if !phenomenonLabelDay.isEmpty {
                            self.phenomenonLabel.text = WeatherCode.getWeather("\(phenomenonLabelDay)")
                            break
                        }

                        if !phenomenonLabelNight.isEmpty {
                            self.phenomenonLabel.text = WeatherCode.getWeather("\(phenomenonLabelNight)")
                        }


                    }

                    self.cityLabel.text = locality
                    
                 
                }
                
          SVProgressHUD.dismiss()
        
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.showWithStatus("Loading...")
    }

}

