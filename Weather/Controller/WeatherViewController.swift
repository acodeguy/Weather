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

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeLocationDelegate {

    // outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var conditionsLabel: UILabel!
    
    //
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUITweaks()
        
        // location manager
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
        locationLabel.text = "Weather Unavailable"
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
                self.locationLabel.text = "Connection Error"
            }
        }
        
    }
    
    func updateWeatherDataModel(weatherDataJSON: JSON) {
        
        if let temperatureResult = weatherDataJSON["main"]["temp"].double {
            
            // convert temperature from Kevlin to Celsius
            weatherDataModel.temperature = Int(temperatureResult - 273.15)
            weatherDataModel.location = "\(weatherDataJSON["name"].stringValue), \(weatherDataJSON["sys"]["country"].stringValue)"
            weatherDataModel.weatherIcon = String(weatherDataModel.updateWeatherIcon(condition: weatherDataJSON["weather"][0]["id"].intValue))
            
            weatherDataModel.conditions = String(weatherDataJSON["weather"][0]["main"].stringValue)
            
            weatherDataModel.backgroundImage = String(weatherDataModel.updateBackgroundImage(condition: weatherDataJSON["weather"][0]["id"].intValue))
                
            updateUI()
            
        } else {
            
            self.view.makeToast("Error getting weather data; typo in location name?")
            locationLabel.text = "Weather Unavailable"
            
        }
    }
    
    func updateUI() {
        
        locationLabel.text = weatherDataModel.location
        temperatureLabel.text = String(weatherDataModel.temperature) + "℃"
        weatherIcon.text = weatherDataModel.weatherIcon
        conditionsLabel.text = weatherDataModel.conditions
        
        updateBackgroundImage()
    
    }
    
    func convertUNIXTimeToHumanTime(UNIXTime: Int) -> String {
        
        let sunTime = Date(timeIntervalSince1970: Double(UNIXTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: sunTime)
    }
    
    @IBAction func getCurrentWeatherPressed(_ sender: Any) {
        
        getWeatherForCurrentLocation()
    }
    
    func getWeatherForCurrentLocation() {
        
        locationManager.startUpdatingLocation()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
//        getWeatherPressed(getWeatherButton)
        
        return false
    }
    
    func updateBackgroundImage() {
        
        backgroundImageView.image = UIImage(named: weatherDataModel.backgroundImage)
        
    }
    func setupUITweaks() {
        
        // mainContainerView
        mainContainerView.layer.cornerRadius = 15
        
    }
    
    @IBAction func searchLocationPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "showLocationSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showLocationSearch" {
            
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetViewController = destinationNavigationController.topViewController as! LocationSearchController
            targetViewController.delegate = self
            
        }
    }
    
    // MARK: ChangeLocationDelegate
    
    func newLocationEntered(lat: String, lon: String) {
        
        let params: [String: String] = [
            "lat" : lat,
            "lon" : lon,
            "appid" : APP_ID
        ]
        
        print("RECIEVED DATA: \(lat), \(lon)")
        
        getWeatherDataFromServer(url: WEATHER_URL, parameters: params)
    }
}

