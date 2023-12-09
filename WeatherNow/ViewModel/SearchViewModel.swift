//
//  SearchViewModel.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 9.12.23.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
        // input
    @Published var city: String
        // output
    @Published var currentWeather1 = WeatherDetail.placeholder
    @Published var hoursWeather1 = WeatherHourModel.placeholder

    init(city:String) {
        self.city = city

        WeatherAPI.shared.fetchWeather(for: city)
            .assign(to: \.currentWeather1 , on: self)
            .store(in: &self.cancellableSet)

        $currentWeather1
            .sink { weather in

            }
            .store(in: &self.cancellableSet)
    }

    func locationWeather(lon: Double, lat: Double) {
        WeatherAPI.shared.fetchWeather(lon: lon, lat: lat)
            .assign(to: \.hoursWeather1, on: self)
            .store(in: &self.cancellableSet)
    }

    func fetchCityWeather(city:String){
        
        WeatherAPI.shared.fetchWeather(for: city)
            .assign(to: \.currentWeather1 , on: self)
            .store(in: &self.cancellableSet)
        $currentWeather1
            .sink { weather in
                let lon = weather.coord.lon
                let lat = weather.coord.lat
                self.locationWeather(lon: lon, lat: lat)
            }
            .store(in: &cancellableSet)

    }

    private var cancellableSet: Set<AnyCancellable> = []
}
