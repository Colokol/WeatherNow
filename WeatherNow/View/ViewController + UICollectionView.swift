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
        if let model = weather?.hourly[indexPath.row] {
            cell.configureCell(model: model, indexPath: indexPath.row)
        }
        return cell
    }
}
