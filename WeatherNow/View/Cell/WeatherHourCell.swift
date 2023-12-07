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
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

   var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weatherIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "background")
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(dayLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(weatherIconImageView)
        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setConstraint() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor,constant: 20),
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            weatherIconImageView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 40),
            weatherIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 5),
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }


}
