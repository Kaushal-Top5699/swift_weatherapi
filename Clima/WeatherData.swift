//
//  WeatherData.swift
//  Clima
//
//  Created by Kaushal Topinkatti B on 23/05/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [WeatherObjects]
}

/*
    Since in our Json data we have an object called main inside of which we have a temp data we wan to access,
    We simply create another struct with that name and then access that data
 */
struct Main: Codable {
    let temp: Double
}

/*
    Since the data we want to fetch is inside of an array named 'weather' which hold array of objects,
    and since these objects have no name, we can name it anything we want but inside of that object we have
    our data named 'description' whose spelling should match our variable
 */
struct WeatherObjects: Codable {
    let description: String
    let id: Int
}

