//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "f7b0cbfeb354e4b8957105f1b47d4a5b"
    // After Submission Please update this to your Api Key after creating account in the WeatherMap and pasting the apikey
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric") else {
            completion(.failure(NetworkError.invalidURL))
            print("Invalid URL: \(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                print("No data received.")
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
