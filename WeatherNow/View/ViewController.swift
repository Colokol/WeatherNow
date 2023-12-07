//
//  ViewController.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var weather: WeatherHourModel = WeatherHourModel.placeholder

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 90)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let Label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 90)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "background")
        return image
    }()
    
    var viewModel = WeatherViewModel()

    var hourCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 6 - 5 , height: (UIScreen.main.bounds.height - 50) / 4.5)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(WeatherHourCell.self, forCellWithReuseIdentifier: WeatherHourCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()

    private let daysTempTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(WeatherDayCell.self, forCellReuseIdentifier: WeatherDayCell.identifier)
        table.backgroundColor = .clear
        table.layer.cornerRadius = 10
        table.clipsToBounds = true
        return table
    }()

    private let searchControler: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultViewController())
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = .black
        return search
        
    }()

    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchControler

        print(viewModel.hoursWeather)
        searchControler.searchBar.delegate = self

        hourCollectionView.delegate = self
        hourCollectionView.dataSource = self

        daysTempTableView.delegate = self
        daysTempTableView.dataSource = self
        
        view.backgroundColor = .white

        view.addSubview(backgroundImageView)
        view.addSubview(hourCollectionView)
        view.addSubview(daysTempTableView)
        view.addSubview(tempLabel)
        view.addSubview(cityLabel)
        setConstrains()
        
        binding()
    }

    func binding() {
        viewModel.$currentWeather
            .sink(receiveValue: {[weak self] currentWeather in
                self?.cityLabel.text = currentWeather.name
                self?.tempLabel.text =
                currentWeather.main?.temp != nil ?
                "\(Int((currentWeather.main?.temp!)!)) ºC"
                : " "}
            )
            .store(in: &cancellable)

        viewModel.$hoursWeather
            .sink(receiveValue: { [weak self] weather in
                self?.weather = weather
                print(weather)
                DispatchQueue.main.async {
                    self?.hourCollectionView.reloadData()
                    self?.daysTempTableView.reloadData()
                }
            })
            .store(in: &cancellable)
    }

    func setConstrains() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 10),

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            hourCollectionView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            hourCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourCollectionView.heightAnchor.constraint(equalToConstant: 150),

            daysTempTableView.topAnchor.constraint(equalTo: hourCollectionView.bottomAnchor, constant: 10),
            daysTempTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            daysTempTableView.leadingAnchor.constraint(equalTo: hourCollectionView.leadingAnchor, constant: 20),
            daysTempTableView.trailingAnchor.constraint(equalTo: hourCollectionView.trailingAnchor, constant: -20),
        ])
    }
}


extension ViewController: UISearchBarDelegate,SearchResultViewControllerDelegate {

    func searchResultDidTap(city: String) {
        viewModel.city = city
        DispatchQueue.main.async { [self] in
            let viewController = ViewController()
            viewController.viewModel = self.viewModel
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        searchResultDidTap(city: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = "London"
        searchResultDidTap(city: searchBar.text!)
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather.hourly.count > 6 ? 6: weather.hourly.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHourCell.identifier, for: indexPath) as? WeatherHourCell else {return UICollectionViewCell()}
        let temp = String(Int(weather.hourly[indexPath.row].temp)) + " ºC"
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather.daily.count > 7 ? 7 : weather.daily.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayCell.identifier) as? WeatherDayCell else {return UITableViewCell()}
        cell.configureTemp(model: weather.daily[indexPath.row], indexPath: indexPath.row)
        return cell
    }


}
