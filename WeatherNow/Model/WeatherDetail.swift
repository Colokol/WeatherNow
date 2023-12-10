//
//  WeatherDetail.swift
//  WeatherNow
//
//  Created by Uladzislau Yatskevich on 7.12.23.
//

import Foundation

    // MARK: - WeatherDetail
struct WeatherDetail: Codable, Identifiable {
    let coord: Coord
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: TimeInterval?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?

    static var placeholder: Self {
        return WeatherDetail(coord: Coord(lon: 1, lat: 1), weather: [], base: nil, main: nil,
                             visibility: nil, wind: nil, clouds: nil, dt: nil,
                             sys: nil, id: nil, name: nil, cod: nil)
    }

    var weatherImageName: String {
        guard let firstWeather = weather?.first else {
            return "defaultImageName"
        }
        let id = firstWeather.id
        switch id {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
}

    // MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

    // MARK: - Main
struct Main: Codable {
    let temp: Double?
    let pressure, humidity: Int?
    let tempMin, tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

    // MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: TimeInterval?//Int?
}

    // MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

    // MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
