//
//  MockData.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation

struct MockData {
    static let weatherResponse = """
    {
        "coord": {"lon": -0.13, "lat": 51.51},
        "weather": [{"id": 300, "main": "Drizzle", "description": "light intensity drizzle", "icon": "09d"}],
        "base": "stations",
        "main": {"temp": 280.32, "feels_like": 278.71, "temp_min": 279.15, "temp_max": 281.48, "pressure": 1012, "humidity": 81},
        "visibility": 10000,
        "wind": {"speed": 4.1, "deg": 80},
        "clouds": {"all": 90},
        "dt": 1560350192,
        "sys": {"type": 1, "id": 1414, "message": 0.0141, "country": "GB", "sunrise": 1560329121, "sunset": 1560388668},
        "timezone": 3600,
        "id": 2643743,
        "name": "London",
        "cod": 200
    }
    """.data(using: .utf8)!
}
