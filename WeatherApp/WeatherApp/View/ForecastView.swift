//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Саша Боднар on 08.10.2023.
//

import UIKit


class ForecastView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cellModels = [ForecastModel]()
    private var forecastW = [Forecastday]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ForecastViewCell.self,
                       forCellReuseIdentifier: ForecastViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchForecastWeather{ [weak self] result in
            switch result {
            case .success(let weather):
                self?.forecastW = weather
                self?.cellModels = weather.compactMap({
                    ForecastModel(text: $0.day.condition?.text ?? "No text",
                                  date: $0.date,
                                  maxtemp_c: $0.day.maxtemp_c ?? 0,
                                  mintemp_c: $0.day.mintemp_c ?? 0,
                                  avgtemp_c: $0.day.avgtemp_c ?? 0,
                                  maxwind_kph: $0.day.maxwind_kph ?? 0,
                                  daily_chance_of_rain: $0.day.daily_chance_of_rain ?? 0,
                                  imageURL: URL(string: "https:\($0.day.condition?.icon ?? "")"))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastViewCell.identifier, for: indexPath) as? ForecastViewCell else {
            fatalError()
        }
        cell.comfigure(with: cellModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
