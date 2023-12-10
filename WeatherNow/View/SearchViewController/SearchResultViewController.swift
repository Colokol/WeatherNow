    //
    //  SearchResultViewController.swift
    //  WeatherNow
    //
    //  Created by Uladzislau Yatskevich on 7.12.23.
    //

import UIKit
import Combine

protocol SearchResultViewControllerDelegate {
    func searchResultDidTap(city:String)
}

class SearchResultViewController: UIViewController {

    var weather: WeatherHourModel = WeatherHourModel.placeholder

    var viewModel: SearchViewModel?


    private var cancellable = Set<AnyCancellable>()

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

    let weatherImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.tintColor = .black
        return image
    }()

    private let backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "background")
        return image
    }()

    var hourCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 40) / 6 - 5 , height: 100)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(WeatherHourCell.self, forCellWithReuseIdentifier: WeatherHourCell.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.1)
        collection.layer.cornerRadius = 10
        collection.clipsToBounds = true
        return collection
    }()

    private let daysTempTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(WeatherDayCell.self, forCellReuseIdentifier: WeatherDayCell.identifier)
        table.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 0.1)
        table.layer.cornerRadius = 10
        table.clipsToBounds = true
        table.showsHorizontalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(weatherImageView)
        setConstrains()

        binding()
    }

    func binding() {

        viewModel?.$hoursWeather1
            .sink(receiveValue: { [weak self] weather in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let temp = weather.current?.temp{
                        self.tempLabel.text = "\(Int(temp)) ºC"
                    }
                    self.cityLabel.text = self.viewModel?.city
                    guard let imageId = weather.current?.weather.first else {return}
                    let image = WeatherHourModel.getWeatherIcon(weather: imageId)
                    self.weatherImageView.image = UIImage(named: image )

                }
                self.weather = weather
                DispatchQueue.main.async {
                    self.hourCollectionView.reloadData()
                    self.daysTempTableView.reloadData()
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

            cityLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 5),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 10),

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weatherImageView.centerXAnchor.constraint(equalTo: tempLabel.centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            weatherImageView.heightAnchor.constraint(equalToConstant: 90),
            weatherImageView.widthAnchor.constraint(equalToConstant: 90),

            hourCollectionView.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            hourCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            hourCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hourCollectionView.heightAnchor.constraint(equalToConstant: 100),

            daysTempTableView.topAnchor.constraint(equalTo: hourCollectionView.bottomAnchor, constant: 10),
            daysTempTableView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            daysTempTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            daysTempTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}



extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weather.hourly.count > 6 ? 6: weather.hourly.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHourCell.identifier, for: indexPath) as? WeatherHourCell else {return UICollectionViewCell()}
        let model = weather.hourly[indexPath.row]
        cell.configureCell(model: model, indexPath: indexPath.row)
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weather.daily.count > 7 ? 7 : weather.daily.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayCell.identifier) as? WeatherDayCell else {return UITableViewCell()}
        cell.configureTemp(model: weather.daily[indexPath.row], indexPath: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
}

