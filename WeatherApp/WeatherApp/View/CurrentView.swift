//
//  ForecastWeatherView.swift
//  WeatherApp
//
//  Created by Саша Боднар on 06.10.2023.
//

import UIKit


class CurrentView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cellModel = [CurrentModel]()
    private var currentW = [Current]()
    private var locate = [Location]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CurrentViewCell.self,
                       forCellReuseIdentifier: CurrentViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchLocation() { [weak self] loca in
            switch loca {
            case .success(let loca):
                self?.locate = [loca]
            case .failure(let error):
                print(error)
            }
        }
        
        fetchCurrentWeather(){ [weak self] result in
            switch result {
            case .success(let weather):
                self?.currentW = [weather]
                self?.cellModel = [weather].compactMap({
                    CurrentModel(lastUpdated: $0.last_updated ?? "No text",
                                 tempC: "\($0.temp_c ?? 0) °C",
                                 windKph: "wind \($0.wind_kph ?? 0) kph",
                                 windDir: "direction \($0.wind_dir ?? "")",
                                 feelslikeC: "feels like  \($0.feelslike_c ?? 0)",
                                 text: self!.locate.first?.name ?? "No town",
                                 textCurrent: $0.condition?.text ?? "",
                                 imageURL: URL(string: "https:\($0.condition?.icon ?? "")"))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .left
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            let detailViewController = ForecastView()
            
            detailViewController.modalPresentationStyle = .fullScreen
            
            let screenWidth = view.frame.size.width
            detailViewController.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: view.frame.size.height)
            
            self.present(detailViewController, animated: false, completion: {
                UIView.animate(withDuration: 1) {
                    detailViewController.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentViewCell.identifier, for: indexPath) as? CurrentViewCell else {
            fatalError()
        }
        cell.configure(with: cellModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 770
    }
}
