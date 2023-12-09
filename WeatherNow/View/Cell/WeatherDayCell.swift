//
//  WheatherDayCell.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import UIKit

class WeatherDayCell: UITableViewCell {

    static let identifier = "WheatherDayCell"

    var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "Сегодня"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "10"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let weatherIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.3)

        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupStackView() {
        let horizontalStackView = UIStackView(arrangedSubviews: [dayLabel,weatherIconImageView,temperatureLabel,])
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = 30
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  20),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            weatherIconImageView.widthAnchor.constraint(equalToConstant: 50),
            dayLabel.widthAnchor.constraint(equalToConstant: 60),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func configureTemp(model: Daily, indexPath: Int){
        if indexPath == 0 {
            dayLabel.text = "Сегодня"
        }else {
            let currentDate = Date()

            let calendar = Calendar.current
            if let Weekday = calendar.date(byAdding: .day, value: indexPath, to: currentDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EE"
                let DayOfWeekString = dateFormatter.string(from: Weekday)
                dayLabel.text = DayOfWeekString

            }
        }
        let minTemp = "\(Int(model.temp.min)) ... \(Int(model.temp.max))" + " ºC"
        temperatureLabel.text = minTemp
        weatherIconImageView.image = UIImage(systemName: "sun.max")
    }


}
