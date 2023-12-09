//
//  ViewController + UITableVIew.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 9.12.23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather!.daily.count > 7 ? 7 : weather!.daily.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayCell.identifier) as? WeatherDayCell else {return UITableViewCell()}
        cell.configureTemp(model: weather!.daily[indexPath.row], indexPath: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
}
