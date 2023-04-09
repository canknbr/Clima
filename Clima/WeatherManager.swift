//
//  WeatherManager.swift
//  Clima
//
//  Created by Can Kanbur on 8.04.2023.
//
import CoreLocation
import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=2fc3bdf086912610c81af0be1574b71c&units=metric"

    var delegate: WeatherManagerDelegate?
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }

                if let safeData = data {
                    if let parsedData = self.getParsejson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: parsedData)
                    }
                }
            }

            task.resume()
        }
    }

    func getParsejson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(WeatherData.self, from: weatherData)
            let id = data.weather[0].id
            let name = data.name
            let temperature = data.main.temp

            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weatherModel

        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
