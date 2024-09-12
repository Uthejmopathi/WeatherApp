//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Uthej Mopathi on 9/11/24.
//

import Foundation
import SwiftUI

class AppCoordinator {
    private let window: UIWindow
    private var weatherView: WeatherView

    init(window: UIWindow) {
        self.window = window
        self.weatherView = WeatherView()
    }

    func start() {
        let hostingController = UIHostingController(rootView: weatherView)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
    }
}
