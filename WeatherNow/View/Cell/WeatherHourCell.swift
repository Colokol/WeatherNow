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
        image.image = UIImage(named: "background")
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStackView()
    }

    func setupStackView() {

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
