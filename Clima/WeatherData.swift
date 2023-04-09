//
//  WeatherData.swift
//  Clima
//
//  Created by Can Kanbur on 8.04.2023.
//

import Foundation

struct WeatherData : Decodable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Decodable {
    let temp : Double
}

struct Weather : Decodable {
    let description : String
    let id : Int
}
