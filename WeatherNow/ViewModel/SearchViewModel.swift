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
    @Published var city: String = ""
        // output
    @Published var currentWeather = WeatherDetail.placeholder
    @Published var hoursWeather = WeatherHourModel.placeholder

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
