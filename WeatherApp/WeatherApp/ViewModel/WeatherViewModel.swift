//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weather: Weather?
    @Published var errorMessage: String?
    @Published var locationAccessGranted: Bool = false
    private let apiKey = "f7b0cbfeb354e4b8957105f1b47d4a5b"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        // locationManager.requestWhenInUseAuthorization() should be called by the View
    }

    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationAccessGranted = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationAccessGranted = false
        @unknown default:
            locationAccessGranted = false
        }
    }
    
    func fetchWeather(for city: String) {
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data"
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.weather = weatherResponse
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse JSON"
                }
            }
        }
        
        task.resume()
    }
    
    func fetchWeather(for location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let urlString = "\(baseUrl)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data"
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.weather = weatherResponse
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse JSON"
                }
            }
        }
        
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchWeather(for: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Failed to get location: \(error.localizedDescription)"
        }
    }
}
