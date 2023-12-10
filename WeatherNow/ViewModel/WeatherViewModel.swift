//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import Combine
import Foundation

final class WeatherViewModel: ObservableObject {

    @Published var city: String = ""
    @Published var currentWeather = WeatherDetail.placeholder
    @Published var hoursWeather = WeatherHourModel.placeholder
    @Published var locationWeather = WeatherHourModel.placeholder

    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $hoursWeather
            .sink { weather in
                guard let city = self.extractCity(from: weather.timezone) else {return}
                self.city = city
            }
            .store(in: &self.cancellableSet)
    }

    func locationWeather(lon: Double, lat: Double) {
        WeatherAPI.shared.fetchWeather(lon: lon, lat: lat)
            .assign(to: \.hoursWeather, on: self)
            .store(in: &self.cancellableSet)
    }


    func extractCity(from timezone: String) -> String? {
        let components = timezone.components(separatedBy: "/")

        if components.count == 2 {
            return components[1]
        } else if let lastComponent = components.last {
            let city = lastComponent.replacingOccurrences(of: "_", with: " ")
            return city
        } else {
            return "Неверный город"
        }
    }

}
