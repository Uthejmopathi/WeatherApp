//
//  Weather.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation

struct Weather: Codable {
    let main: Main
    let weather: [WeatherDetails]
    let name: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct WeatherDetails: Codable {
    let main: String
    let icon: String
}
