//
//  ViewCurrentCellModel.swift
//  WeatherApp
//
//  Created by Саша Боднар on 06.10.2023.
//


import UIKit


class CurrentModel {
    
    let lastUpdated: String?
    let tempC: String?
    let windKph: String?
    let windDir: String?
    let feelslikeC: String?
    let imageURL: URL?
    let text: String
    let textCurrent: String?
    var imageData: Data? = nil
    
    
    init(lastUpdated: String, tempC: String, windKph: String, windDir: String, feelslikeC: String, text: String, textCurrent: String, imageURL: URL?) {
        self.lastUpdated = lastUpdated
        self.tempC = tempC
        self.windKph = windKph
        self.windDir = windDir
        self.feelslikeC = feelslikeC
        self.text = text
        self.textCurrent = textCurrent
        self.imageURL = imageURL
    }
}

class CurrentViewCell: UITableViewCell {
    
    static let identifier = "CurrentViewCell"
    
    private let cityName : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .medium)
        return label
    }()
    
    private let textCurrent : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 27, weight: .light)
        return label
    }()
    
    private let tempC : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .regular)
        return label
    }()
    
    private let feelslike : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 27, weight: .light)
        return label
    }()
    
    private let windKph : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let winDr : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cityName)
        contentView.addSubview(dateInfo)
        contentView.addSubview(newsImageView)
        contentView.addSubview(textCurrent)
        contentView.addSubview(tempC)
        contentView.addSubview(feelslike)
        contentView.addSubview(winDr)
        contentView.addSubview(windKph)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cityName.frame = CGRect(x: contentView.frame.midX-35, y: 80,
                                width: contentView.frame.size.width - 170,
                                height: 70)
        
        textCurrent.frame = CGRect(x: contentView.frame.midX-75, y: 110,
                                   width: contentView.frame.size.width - 150,
                                   height: 70)
        
        newsImageView.frame = CGRect(x: (contentView.center.x)-100,
                                     y: (contentView.frame.size.width / 2)-10,
                                     width:  200, height:  200)
        
        tempC.frame = CGRect(x: contentView.frame.size.width - 235, y: 240,
                             width: contentView.frame.size.width - 170,
                             height: contentView.frame.size.height / 2)
        
        feelslike.frame = CGRect(x: contentView.frame.size.width - 277, y: 280,
                                 width: contentView.frame.size.width - 170,
                                 height: contentView.frame.size.height / 2)
        
        windKph.frame = CGRect(x: contentView.frame.size.width - 310, y: 320,
                               width: contentView.frame.size.width - 170,
                               height: contentView.frame.size.height / 2)
        
        winDr.frame = CGRect(x: contentView.frame.size.width - 180, y: 320,
                             width: contentView.frame.size.width - 170,
                             height: contentView.frame.size.height / 2)
        
        
        dateInfo.frame = CGRect(x: (contentView.center.x)-70, y: 550,
                                width: contentView.frame.size.width - 170,
                                height: contentView.frame.size.height / 2)}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        cityName.text = nil
        feelslike.text = nil
        tempC.text = nil
        winDr.text = nil
        windKph.text = nil
        dateInfo.text = nil
        textCurrent.text = nil
    }
    
    func configure(with viewModel: CurrentModel){
        cityName.text = viewModel.text
        dateInfo.text = viewModel.lastUpdated
        tempC.text = ("\(viewModel.tempC ?? "")")
        feelslike.text = ("\(viewModel.feelslikeC ?? "")")
        winDr.text = viewModel.windDir
        windKph.text = ("\(viewModel.windKph ?? "")")
        textCurrent.text = viewModel.textCurrent
        
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

