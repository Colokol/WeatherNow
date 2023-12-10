
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
    let lastSaveDate: Date
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

    private var lang:String {
        guard let firstLanguageCode = Locale.preferredLanguages.first else {
            return "en"
        }
        let languageCode = firstLanguageCode.components(separatedBy: "-").first ?? firstLanguageCode
        return languageCode
    }

    private var cache: [String: CachedWeatherHourModel] = [:]

    func URLHourWeather(lon:Double, lat:Double) -> URL?  {

        let queryURL = Foundation.URL(string: baseaseURL3)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "lat", value: "\(lat)"),
                                    URLQueryItem(name: "lon", value: "\(lon)"),
                                    URLQueryItem(name: "units", value: units),
                                    URLQueryItem(name: "lang", value: lang)]
        return urlComponents.url
    }

    private func URLWeather(city: String) -> URL? {
        let queryURL = Foundation.URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: units),
                                    URLQueryItem(name: "lang", value: lang)]
        return urlComponents.url
    }

    private func URLWeather(lon: Double, lat: Double) -> URL? {
        let queryURL = Foundation.URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil}
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "lon", value: "\(lon)"),
                                    URLQueryItem(name: "lat", value: "\(lat)"),
                                    URLQueryItem(name: "units", value: units),
                                    URLQueryItem(name: "lang", value: lang)]
        return urlComponents.url
    }

    func fetchLocalWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherHourModel, Never> {

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
                let decodingData = try! JSONEncoder().encode(data)
                let cacheData = CachedWeatherHourModel(data: decodingData, lastSaveDate: Date())
                self?.saveToCache(data: cacheData, key: "lastLocation")
            })
            .catch { error in
                print("Error fetching hour weather: \(error)")
                return Just(WeatherHourModel.placeholder)
            }
            .eraseToAnyPublisher()
    }

    func fetchDetailWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherDetail, Never> {
        guard let url = URLWeather(lon: lon, lat: lat) else {
            return Just(WeatherDetail.placeholder)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for:url)
            .map { $0.data }
            .decode(type: WeatherDetail.self, decoder: JSONDecoder())
            .catch { error in
                print("Error fetching hour weather: \(error)")
                return Just(WeatherDetail.placeholder)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherHourModel, Never> {
        guard let url = URLHourWeather(lon: lon, lat: lat) else {
            return Just(WeatherHourModel.placeholder)
                .eraseToAnyPublisher()
        }
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

    func saveToCache(data: CachedWeatherHourModel, key: String) {
        UserDefaults.standard.set(data.data, forKey: key)
        UserDefaults.standard.set(data.lastSaveDate, forKey: "\(key)Time")
    }

}
