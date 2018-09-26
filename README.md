# Weather
## A simple weather app for iOS 12 iPhone that accesses live weather data from OpenWeatherMap's free API

![Weather](https://acodeguy.com/img/portfolio/ios-weather.jpg)

### Features
- Current weather conditions for current location
- Current weather conditions for any given location (search)

## Installation

#### Requirements
- Xcode 10+ with an iOS 12+ simulator
- Cocoapods 1.5.3+ (AlamoFire, SwifyJSON, SVProgressHUD, Toast-Swift)
- An OpenWeatherMap API key

#### Installation steps
1. Clone the repo: `git clone https://github.com/acodeguy/weather`
2. Run `pod update` (in project root)
3. Add a Constants.swift file in the root folder of your project (same folder with Info.plist, Assets.xcassets, etc)
4. Add the OMW API key and URL

##### Adding Constants.swft file and its content:

Right-click the yellow Weather folder in your project navigator, New File. Select Swift file. Paste in the below code with your own OpenWeatherMap API key:

```
import Foundation

let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"

let APP_ID = "YOUR API KEY HERE"
```


## License
This project is provided under the GNU General Public License v3.0.
Please read LICENSE.md for details.
