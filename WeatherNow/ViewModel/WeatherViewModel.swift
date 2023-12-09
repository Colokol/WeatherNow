//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import Combine
import Foundation

final class WeatherViewModel: ObservableObject {
        // input
    @Published var city: String = ""
        // output
    @Published var currentWeather = WeatherDetail.placeholder
    @Published var hoursWeather = WeatherHourModel.placeholder
    @Published var locationWeather = WeatherHourModel.placeholder

    init() {
//        $city
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .flatMap { (city:String) -> AnyPublisher <WeatherDetail, Never> in
//                WeatherAPI.shared.fetchWeather(for: city)
//            }
//            .assign(to: \.currentWeather , on: self)
//            .store(in: &self.cancellableSet)
//
//        $currentWeather
//            .compactMap { currentWeather in
//                guard let lon = currentWeather.coord?.lon, let lat = currentWeather.coord?.lat else {
//                    return nil
//                }
//                return (String(lon), String(lat))
//            }
//            .debounce(for: 0.3, scheduler: RunLoop.main)
//            .flatMap { (lon: String, lat: String) -> AnyPublisher<WeatherHourModel, Never> in
//                WeatherAPI.shared.fetchHourWeather(lon: lon, lat: lat)
//            }
//            .assign(to: \.hoursWeather, on: self)
//            .store(in: &self.cancellableSet)
    }

    func locationWeather(lon: Double, lat: Double) {
        WeatherAPI.shared.fetchHourWeather(lon: lon, lat: lat)
            .assign(to: \.hoursWeather, on: self)
            .store(in: &self.cancellableSet)
    }

    func fetchCityWeather(city:String){
        WeatherAPI.shared.fetchWeather(for: city)
            .assign(to: \.currentWeather , on: self)
            .store(in: &self.cancellableSet)
        $currentWeather
            .sink { weather in
                let lon = weather.coord.lon
                let lat = weather.coord.lat
                self.locationWeather(lon: lon, lat: lat)
            }
            .store(in: &cancellableSet)

    }

    private var cancellableSet: Set<AnyCancellable> = []
}
