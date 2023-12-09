
    //
    //  WeatherAPI.swift
    //  WeatherNow
    //
    //  Created by Uladzislau Yatskevich on 7.12.23.
    //

import Foundation
import Combine
import Network

struct CachedWeatherHourModel {
    let data: Data
    let expirationDate: Date
}

class WeatherAPI {
    static let shared = WeatherAPI()

    private let baseaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "a18d790c81d2bcb7aa9d7d3c4c9e103b"
    private let baseaseURL3 = "https://api.openweathermap.org/data/3.0/onecall"
    private let excludeHour = "hourly"
    private var units: String {
        return "metric"
    }

    private var cache: [String: CachedWeatherHourModel] = [:]
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkUpdate(path: path)
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    private var isNetworkAvailable: Bool {
        return monitor.currentPath.status == .satisfied
    }

    func URLHourWeather(lon:Double, lat:Double) -> URL?  {

        let queryURL = Foundation.URL(string: baseaseURL3)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "lat", value: "\(lat)"),
                                    URLQueryItem(name: "lon", value: "\(lon)"),
                                    URLQueryItem(name: "units", value: units) ]
        return urlComponents.url
    }

    private func URLWeather(city: String) -> URL? {
        let queryURL = Foundation.URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }

    func fetchLocalWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherHourModel, Never> {
        guard isNetworkAvailable else {

            if let cachedData = loadFromCache(key: "last"),
               let cachedWeather = try? JSONDecoder().decode(WeatherHourModel.self, from: cachedData) {
                return Just(cachedWeather)
                    .eraseToAnyPublisher()
            }

            return Just(WeatherHourModel.placeholder)
                .eraseToAnyPublisher()
        }

        guard let url = URLHourWeather(lon: lon, lat: lat) else {
            return Just(WeatherHourModel.placeholder)
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Cache-Control": "no-store, max-age=0"]

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard 200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: WeatherHourModel.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { [weak self] data in
                self?.saveToCache(data: try! JSONEncoder().encode(data), key: "last")
            })
            .catch { error in
                print("Error fetching hour weather: \(error)")
                return Just(WeatherHourModel.placeholder)
            }
            .eraseToAnyPublisher()
    }

    func fetchWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherHourModel, Never> {
        guard let url = URLHourWeather(lon: lon, lat: lat) else {
            return Just(WeatherHourModel.placeholder)
                .eraseToAnyPublisher()
        }
        print(url)
        return URLSession.shared.dataTaskPublisher(for:url)
            .map { $0.data }
            .decode(type: WeatherHourModel.self, decoder: JSONDecoder())
            .catch { error in
                print("Error fetching hour weather: \(error)")
                return Just(WeatherHourModel.placeholder)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchWeather(for city: String) -> AnyPublisher<WeatherDetail, Never> {
        guard let url = URLWeather(city: city) else {
            return Just(WeatherDetail.placeholder)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for:url)
            .map { $0.data }
            .decode(type: WeatherDetail.self, decoder: JSONDecoder())
            .catch { error in Just(WeatherDetail.placeholder)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }


    private func handleNetworkUpdate(path: NWPath) {
        if path.status == .satisfied {
            print("Network is available")
        } else {
            print("Network is not available")
        }
    }

    func saveToCache(data: Data, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }

    func loadFromCache(key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }

}