//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Саша Боднар on 04.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let weatherData = Location(name: "Paris", region: "Ile-de-France", country: "France", localtime: "2023-10-06 21:04")  // Замініть на фактичні дані
        saveWeatherData(weatherData)
    }
    func saveWeatherData(_ weatherData: Location) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(weatherData) {
            defaults.set(encoded, forKey: "weatherData")
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let savedData = UserDefaults.standard.data(forKey: "weatherData") {
            let decoder = JSONDecoder()
            if let weatherData = try? decoder.decode(Location.self, from: savedData) {
                // Display the loaded weather data in your UI
            }
        }
                    return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

