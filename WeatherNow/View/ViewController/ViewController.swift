    //
    //  ViewController.swift
    //  WeatherNow
    //
    //  Created by Uladzislau Yatskevich on 7.12.23.
    //

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {

    var weather: WeatherHourModel?
    var viewModel = WeatherViewModel()

    private let locationManager = CLLocationManager()
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

    private let oldWeatherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weatherImageView: UIImageView = {
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

    private let hourCollectionView: UICollectionView = {
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

    private let searchControler: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = .black
        search.definesPresentationContext = false
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchControler

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

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
        view.addSubview(weatherImageView)
        view.addSubview(oldWeatherLabel)

        setConstrains()
        binding()
    }


    func binding() {
        viewModel.$hoursWeather
            .sink(receiveValue: { [weak self] weather in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let temp = weather.current?.temp{
                        self.tempLabel.text = "\(Int(temp)) ºC"
                    }
                    self.cityLabel.text = self.viewModel.city
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


extension ViewController: UISearchBarDelegate, SearchResultViewControllerDelegate {

    func searchResultDidTap(city: String) {
        DispatchQueue.main.async { [self] in
            let viewController = SearchResultViewController()
            viewController.viewModel = SearchViewModel(city: city)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        searchResultDidTap(city: text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }

}

extension ViewController: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        viewModel.locationWeather(lon: lon, lat: lat)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error)")
    }

}


