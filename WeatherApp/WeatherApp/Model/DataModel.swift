//
//  ModelForecastWeather.swift
//  WeatherApp
//
//  Created by Саша Боднар on 04.10.2023.
//

import Foundation


struct ModelForecastWeather: Decodable {
    var location: Location
    var forecast: Forecast
    var current: Current
}

struct Location: Decodable, Encodable {
    let name, region, country: String?
    let localtime: String
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct Forecastday: Decodable {
    let date: String
    let day: Day
}

struct Day: Decodable {
    let maxtemp_c, mintemp_c: Double?
    let avgtemp_c, maxwind_kph: Double?
    let daily_chance_of_rain: Int?
    let condition: Condition?
}

struct Condition: Decodable {
    let text: String
    let icon: String
}

struct Current: Decodable {
    let last_updated: String?
    let temp_c: Int?
    let condition: Condition?
    let wind_kph: Double?
    let wind_dir: String?
    let feelslike_c: Double?
    let vis_km: Double?
}
