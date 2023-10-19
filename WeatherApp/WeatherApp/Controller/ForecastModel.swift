//
//  ViewCellModel.swift
//  WeatherApp
//
//  Created by Саша Боднар on 06.10.2023.
//

import UIKit


class ForecastModel {
    
    let date: String
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let maxwind_kph: Double
    let daily_chance_of_rain: Int
    let text: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    
    init(text: String, date: String, maxtemp_c: Double, mintemp_c: Double, avgtemp_c: Double, maxwind_kph: Double, daily_chance_of_rain: Int, imageURL: URL?) {
        self.text = text
        self.date = date
        self.maxtemp_c = maxtemp_c
        self.mintemp_c = mintemp_c
        self.avgtemp_c = avgtemp_c
        self.maxwind_kph = maxwind_kph
        self.daily_chance_of_rain = daily_chance_of_rain
        self.imageURL = imageURL
    }
}

class ForecastViewCell: UITableViewCell {
    
    static let identifier = "ForecastViewCell"
    
    private let mainText : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let average : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 36, weight: .regular)
        return label
    }()
    
    private let mindegree : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let maxdegree : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let dailychance : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let maxwind : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let dateInfo : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mainText)
        contentView.addSubview(dateInfo)
        contentView.addSubview(average)
        contentView.addSubview(mindegree)
        contentView.addSubview(maxdegree)
        contentView.addSubview(newsImageView)
        contentView.addSubview(maxwind)
        contentView.addSubview(dailychance)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainText.frame = CGRect(x: 15, y: 72,
                                width: contentView.frame.size.width - 170,
                                height: 70)
        
        average.frame = CGRect(x: 290, y: 10,
                               width: contentView.frame.size.width - 170,
                               height: 70)
        
        mindegree.frame = CGRect(x: 290, y: 65,
                                 width: contentView.frame.size.width - 170,
                                 height: 70)
        
        maxdegree.frame = CGRect(x: 330, y: 65,
                                 width: contentView.frame.size.width - 170,
                                 height: 70)
        
        dailychance.frame = CGRect(x: 330, y: 95,
                                   width: contentView.frame.size.width - 170,
                                   height: 70)
        
        maxwind.frame = CGRect(x: 290, y: 95,
                               width: contentView.frame.size.width - 170,
                               height: 70)
        
        dateInfo.frame = CGRect(x: 15, y: 95,
                                width: contentView.frame.size.width - 170,
                                height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(x: 15, y: 15,
                                     width: 80,
                                     height: contentView.frame.size.height - 85)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        mainText.text = nil
        dateInfo.text = nil
        average.text = nil
        mindegree.text = nil
        maxdegree.text = nil
        maxwind.text = nil
        dailychance.text = nil
    }
    
    func comfigure(with viewModel: ForecastModel){
        mainText.text = viewModel.text
        dateInfo.text = viewModel.date
        average.text = ("\(viewModel.avgtemp_c)")
        mindegree.text = ("\(viewModel.mintemp_c)")
        maxdegree.text = ("\(viewModel.maxtemp_c)")
        maxwind.text = ("\(viewModel.maxwind_kph)")
        dailychance.text = ("\(viewModel.daily_chance_of_rain)")
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else  if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self](data, _, error) in
                guard let data = data, error == nil else{
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}

