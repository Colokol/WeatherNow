//
//  WeatherViewModel.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import Combine
import Foundation
import Network

final class WeatherViewModel: ObservableObject {

    @Published var city: String = ""
    @Published var currentWeather = WeatherDetail.placeholder
    @Published var hoursWeather = WeatherHourModel.placeholder
    @Published var locationWeather = WeatherHourModel.placeholder


    private var cancellableSet: Set<AnyCancellable> = []
    private let monitor = NWPathMonitor()
    private var isNetworkAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }
    var coordLon: Double = 0.0
    var coordLat: Double = 0.0
    
    init() {

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)

        $currentWeather
            .sink { weather in
                guard let city = weather.name else {return}
                self.city = city
                self.saveNameCity(name: city)
                print(city)
            }
            .store(in: &self.cancellableSet)
    }

    func locationWeather(lon: Double, lat: Double) {

        if isNetworkAvailable {
            WeatherAPI.shared.fetchLocalWeather(lon: lon, lat: lat)
                .assign(to: \.hoursWeather, on: self)
                .store(in: &self.cancellableSet)
            WeatherAPI.shared.fetchDetailWeather(lon: lon, lat: lat)
                .assign(to: \.currentWeather, on: self)
                .store(in: &self.cancellableSet)
        
        }else {
            if let cachedData = loadFromCache(key: "lastLocation"),
               let cachedWeather = try? JSONDecoder().decode(WeatherHourModel.self, from: cachedData) {
                hoursWeather = cachedWeather
            }
            if let city = UserDefaults.standard.object(forKey: "City"){
                self.city = city as? String ?? ""
            }
        }
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

    func saveNameCity(name:String, key:String = "City"){
        UserDefaults.standard.set(name, forKey: key)
    }

    func loadFromCache(key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }

}
