//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""
    @State private var locationGranted: Bool = false
    
    private let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let textColor = Color.white
    private let cardColor = Color.white.opacity(0.9)
    
    var body: some View {
        ZStack {
            backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField(NSLocalizedString("enterCityPlaceholder", comment: "Placeholder for city input"), text: $city, onCommit: {
                    viewModel.fetchWeather(for: city)
                    saveLastCity()
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(cardColor)
                .cornerRadius(10)
                .padding(.horizontal)
                .accessibilityLabel(NSLocalizedString("cityTextFieldLabel", comment: "Text field for entering city"))
                .accessibilityHint(NSLocalizedString("cityTextFieldHint", comment: "Hint for entering city"))
                
                if let weather = viewModel.weather {
                    WeatherCard(weather: weather)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(String(format: NSLocalizedString("errorMessage", comment: ""), errorMessage))
                        .accessibility(identifier: "errorMessage")
                        .accessibilityLabel(String(format: NSLocalizedString("errorMessage", comment: ""), errorMessage))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text(String(format: NSLocalizedString("placeholderText", comment: "")))
                        .foregroundColor(textColor)
                        .padding()
                }
            }
        }
        .onAppear {
            checkLocationAuthorizationStatus()
            if let lastCity = loadLastCity() {
                city = lastCity
                viewModel.fetchWeather(for: lastCity)
            } else {
                viewModel.fetchWeather(for: "New York")
            }
        }
    }
    
    private func saveLastCity() {
        UserDefaults.standard.set(city, forKey: "lastSearchedCity")
    }
    
    private func loadLastCity() -> String? {
        UserDefaults.standard.string(forKey: "lastSearchedCity")
    }
    
    private func checkLocationAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            viewModel.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationGranted = true
            viewModel.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            locationGranted = false
            // Optionally handle denied or restricted state
        @unknown default:
            locationGranted = false
            // Handle unknown case if needed
        }
    }
}



struct WeatherCard: View {
    let weather: Weather
    
    private let cardColor = Color.white.opacity(0.8)
    
    var body: some View {
        VStack {
            Text(weather.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(String(format: NSLocalizedString("temperature", comment: "Temperature description"), locale: Locale.current, weather.main.temp))
                .font(.title2)
                .padding(.vertical)
            
            Text(String(format: NSLocalizedString("humidity", comment: "Humidity description"), locale: Locale.current, weather.main.humidity))
                .font(.title3)
                .padding(.bottom)
            
            if let icon = weather.weather.first?.icon {
                let iconUrl = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
                
                AsyncImage(url: iconUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    case .failure(let error):
                        Text("Failed to load image: \(error.localizedDescription)")
                            .frame(width: 100, height: 100)
                    @unknown default:
                        Text("Unknown error")
                            .frame(width: 100, height: 100)
                    }
                }
            } else {
                Text("Icon not available")
            }
        }
        .padding()
        .background(cardColor)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
