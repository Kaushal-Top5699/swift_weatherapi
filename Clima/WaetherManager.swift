//
//  WaetherManager.swift
//  Clima
//
//  Created by Kaushal Topinkatti B on 22/05/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=YOUR_API_KEY&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeatherByLatLon(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            //print(weather.temperatureString)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
}
