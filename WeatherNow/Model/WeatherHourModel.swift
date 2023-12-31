
import Foundation

    // MARK: - WeatherHourModel
struct WeatherHourModel: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current?
    let hourly: [Hourly]
    let daily: [Daily]

    static var placeholder: Self {
        return WeatherHourModel(lat: 0, lon: 0, timezone: "", timezoneOffset: 0, current: nil , hourly: [], daily: [])
    }

    static func getWeatherIcon(weather:Weather) -> String {
        let weatherId = weather.id
        switch weatherId {
            case 200...232:
                return "11d"
            case 300...321:
                return "09d"
            case 500...531:
                return "10d"
            case 600...622:
                return "13d"
            case 701...781:
                return "50d"
            case 800:
                return "01d"
            case 801...804:
                return "02d"
            default:
                return "02d"
        }
    }

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
        case timezone = "timezone"
        case timezoneOffset = "timezone_offset"
        case current = "current"
        case hourly = "hourly"
        case daily = "daily"
    }
}

    // MARK: - Current
struct Current: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feelsLike: Double?
    let pressure: Int?
    let humidity: Int?
    let dewPoint: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case temp = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dewPoint = "dew_point"
        case uvi = "uvi"
        case clouds = "clouds"
        case visibility = "visibility"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather = "weather"
    }
}

    // MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}

    // MARK: - Daily
struct Daily: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let moonrise: Int?
    let moonset: Int?
    let moonPhase: Double?
    let summary: String?
    let temp: Temp
    let feelsLike: FeelsLike?
    let pressure: Int?
    let humidity: Int?
    let dewPoint: Double?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int?
    let pop: Double?
    let uvi: Double?
    let snow: Double?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case moonrise = "moonrise"
        case moonset = "moonset"
        case moonPhase = "moon_phase"
        case summary = "summary"
        case temp = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather = "weather"
        case clouds = "clouds"
        case pop = "pop"
        case uvi = "uvi"
        case snow = "snow"
    }
}

    // MARK: - FeelsLike
struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double

    enum CodingKeys: String, CodingKey {
        case day = "day"
        case night = "night"
        case eve = "eve"
        case morn = "morn"
    }
}

    // MARK: - Temp
struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double

    enum CodingKeys: String, CodingKey {
        case day = "day"
        case min = "min"
        case max = "max"
        case night = "night"
        case eve = "eve"
        case morn = "morn"
    }
}

    // MARK: - Hourly
struct Hourly: Codable {
    let dt: Int?
    let temp: Double
    let feelsLike: Double?
    let pressure: Int?
    let humidity: Int?
    let dewPoint: Double?
    let uvi: Double?
    let clouds: Int?
    let visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let windGust: Double?
    let weather: [Weather]
    let pop: Double?
    let snow: Snow?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case temp = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case dewPoint = "dew_point"
        case uvi = "uvi"
        case clouds = "clouds"
        case visibility = "visibility"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather = "weather"
        case pop = "pop"
        case snow = "snow"
    }
}

    // MARK: - Snow
struct Snow: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

    // MARK: - Minutely
struct Minutely: Codable {
    let dt: Int
    let precipitation: Int

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case precipitation = "precipitation"
    }
}

