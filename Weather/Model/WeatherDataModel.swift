//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Andrew. on 15/09/2018.
//  Copyright © 2018 A Code Guy. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    var temperature: Int = 0
    var weatherIcon: String = ""
    var location: String = ""
    var backgroundImage: String = ""
    
    func updateBackgroundImage(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "thunderstorm"
            
        case 301...500 :
            return "lightrain"
            
        case 501...600 :
            return "shower"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "thunderstorm"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy"
            
        case 900...903, 905...1000  :
            return "thunderstorm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "nebula"
        }
        
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "🌩"
            
        case 301...500 :
            return "🌧"
            
        case 501...600 :
            return "☔️"
            
        case 601...700 :
            return "❄️"
            
        case 701...771 :
            return "🌁"
            
        case 772...799 :
            return "🌩"
            
        case 800 :
            return "☀"
            
        case 801...804 :
            return "☁️"
            
        case 900...903, 905...1000  :
            return "🌩"
            
        case 903 :
            return "❄️"
            
        case 904 :
            return "☀️"
            
        default :
            return "dunno"
        }
        
    }
}

