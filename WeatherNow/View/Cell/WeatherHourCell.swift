//
//  CollectionViewCell.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import UIKit

class WeatherHourCell: UICollectionViewCell {

    static let identifier = "WeatherHourCell"

    var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weatherIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.tintColor = .black
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    func configureCell(model:Hourly, indexPath:Int){

        //let temp = String(Int(weather!.hourly[indexPath.row].temp)) + " ºC"
        if indexPath == 0 {
            dayLabel.text = "Сейчас"
        }else {
            let currentDate = Date()
            let calendar = Calendar.current

            let hour = calendar.component(.hour, from: currentDate)
            dayLabel.text = "\(hour + indexPath)"
        }
        let temp = Int(model.temp)
        temperatureLabel.text = "\(temp) ºC"
        guard let imageId =  model.weather.first else {return}
        let image = WeatherHourModel.getWeatherIcon(weather: imageId)
        weatherIconImageView.image = UIImage(named: image)
    }

    func setupView() {

        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(temperatureLabel)

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.heightAnchor.constraint(equalToConstant: 15),

            weatherIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            temperatureLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }



    required init?(coder: NSCoder) {
        fatalError()
    }
}
