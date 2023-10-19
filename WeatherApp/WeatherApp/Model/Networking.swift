//
//  Networking.swift
//  WeatherApp
//
//  Created by Саша Боднар on 04.10.2023.
//

import Alamofire
import Foundation


let urlForecast: String = "http://api.weatherapi.com/v1/forecast.json?key=6aa5fe638f51420381a92552230410&q=Paris&days=7&aqi=no&alerts=no"

func fetchForecastWeather(completion: @escaping (Result<[Forecastday], Error>) -> Void) {
    AF.request(urlForecast, method: .get)
        .response {  response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(ModelForecastWeather.self, from: data!)
                    completion(.success(jsonData.forecast.forecastday))
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
}

let urlCurrent: String = "http://api.weatherapi.com/v1/forecast.json?key=6aa5fe638f51420381a92552230410&q=Paris&days=7&aqi=no&alerts=no"

func fetchCurrentWeather(completion: @escaping (Result<Current, Error>) -> Void) {
    AF.request(urlCurrent, method: .get)
        .response {  response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(ModelForecastWeather.self, from: data!)
                    completion(.success(jsonData.current))
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
}

func fetchLocation(completion: @escaping (Result<Location, Error>) -> Void) {
    AF.request(urlForecast, method: .get)
        .response {  response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonData = try JSONDecoder().decode(ModelForecastWeather.self, from: data!)
                    completion(.success(jsonData.location))
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
}
