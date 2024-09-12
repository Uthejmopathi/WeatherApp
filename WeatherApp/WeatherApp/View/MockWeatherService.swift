//
//  MockWeatherService.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation
@testable import WeatherApp // Replace with your app module name

class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false
    
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else {
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(Weather.self, from: MockData.weatherResponse)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
