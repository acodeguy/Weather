//
//  ViewController.swift
//  Weather
//
//  Created by Andrew. on 14/09/2018.
//  Copyright © 2018 A Code Guy. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Toast_Swift

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var getWeatherButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var locationSearchTextField: UITextField!
    @IBOutlet weak var weatherIcon: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainContainerView: UIView!
    
    //
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUITweaks()
        
        locationSearchTextField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        getWeatherForCurrentLocation()
        
    }
    
    
    
    // locationManager stuff
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("locations found")
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            // valid result obtained, stop updating location
            locationManager.stopUpdatingLocation()
            
            //
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            // build parameter dictionary to make call
            let openWeatherMapParameters: [String:String] = [
                "lat": latitude,
                "lon": longitude,
                "appid": APP_ID
                ]
            
            getWeatherDataFromServer(url: WEATHER_URL, parameters: openWeatherMapParameters)
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.view.makeToast("There was an error getting your location.")
        cityLabel.text = "Weather Unavailable"
    }
    
    //
    
    func getWeatherDataFromServer(url: String, parameters: [String:String]) {
        
        SVProgressHUD.show()
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            
            response in
            
            if response.result.isSuccess {
                
                SVProgressHUD.dismiss()
                
                let weatherDataJSON: JSON = JSON(response.result.value!)
                print(weatherDataJSON)
                self.updateWeatherDataModel(weatherDataJSON: weatherDataJSON)
                
            } else {
                
                SVProgressHUD.dismiss()
                
                self.view.makeToast("There was an error getting the weather data from the server.")
                self.cityLabel.text = "Connection Error"
            }
        }
        
    }
    
    func updateWeatherDataModel(weatherDataJSON: JSON) {
        
        if let temperatureResult = weatherDataJSON["main"]["temp"].double {
            
            // convert temperature from Kevlin to Celsius
            weatherDataModel.temperature = Int(temperatureResult - 273.15)
            weatherDataModel.city = weatherDataJSON["name"].stringValue
            weatherDataModel.country = weatherDataJSON["sys"]["country"].stringValue
            weatherDataModel.weatherIcon = String(weatherDataModel.updateWeatherIcon(condition: weatherDataJSON["weather"][0]["id"].intValue))
            
            weatherDataModel.sunrise = weatherDataJSON["sys"]["sunrise"].intValue
            weatherDataModel.sunset = weatherDataJSON["sys"]["sunset"].intValue
            
            weatherDataModel.backgroundImage = String(weatherDataModel.updateBackgroundImage(condition: weatherDataJSON["weather"][0]["id"].intValue))
            
            weatherDataModel.conditionDescription = weatherDataJSON["weather"][0]["description"].stringValue
                
            updateUI()
            
        } else {
            
            self.view.makeToast("Error getting weather data; typo in location name?")
            cityLabel.text = "Weather Unavailable"
            
        }
    }
    
    func updateUI() {
        
        cityLabel.text = weatherDataModel.city
        countryLabel.text = weatherDataModel.country
        temperatureLabel.text = String(weatherDataModel.temperature) + "℃"
        weatherIcon.text = weatherDataModel.weatherIcon
        conditionLabel.text = weatherDataModel.conditionDescription
        sunriseLabel.text = "SUNRISE: " + convertUNIXTimeToHumanTime(UNIXTime: Int(weatherDataModel.sunrise))
        sunsetLabel.text = "SUNSET: " + convertUNIXTimeToHumanTime(UNIXTime: Int(weatherDataModel.sunset))
        
        updateBackgroundImage()
    
    }
    
    func convertUNIXTimeToHumanTime(UNIXTime: Int) -> String {
        
        let sunTime = Date(timeIntervalSince1970: Double(UNIXTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: sunTime)
    }

    @IBAction func getWeatherPressed(_ sender: UIButton) {
        
        let newLocation = locationSearchTextField.text!
        
        let params: [String:String] = [
            
            "q": newLocation,
            "appid": APP_ID
        ]
        
        locationSearchTextField.text = ""
        
        getWeatherDataFromServer(url: WEATHER_URL, parameters: params)
    }
    
    @IBAction func getCurrentWeatherPressed(_ sender: Any) {
        
        getWeatherForCurrentLocation()
    }
    
    func getWeatherForCurrentLocation() {
        
        locationManager.startUpdatingLocation()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        getWeatherPressed(getWeatherButton)
        
        return false
    }
    
    func updateBackgroundImage() {
        
        backgroundImageView.image = UIImage(named: weatherDataModel.backgroundImage)
        
    }
    func setupUITweaks() {
        
        // mainContainerView
        mainContainerView.layer.cornerRadius = 15
        
    }
    
}

