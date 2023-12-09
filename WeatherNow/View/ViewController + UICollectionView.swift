//
//  ViewController + UICollectionView.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 9.12.23.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather!.hourly.count > 6 ? 6: weather!.hourly.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHourCell.identifier, for: indexPath) as? WeatherHourCell else {return UICollectionViewCell()}


        let temp = String(Int(weather!.hourly[indexPath.row].temp)) + " ºC"
        if indexPath.row == 0 {
            cell.dayLabel.text = "Сейчас"
        }else {
            let currentDate = Date()
            let calendar = Calendar.current

            let hour = calendar.component(.hour, from: currentDate)
            cell.dayLabel.text = "\(hour + indexPath.row)"
        }

        cell.temperatureLabel.text = temp
        cell.weatherIconImageView.image = UIImage(systemName: "sun.min")
        return cell
    }
}
