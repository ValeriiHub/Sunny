//
//  NetworkWeatherManager.swift
//  Sunny
//
//  Created by Valerii D on 04.07.2021.
//  Copyright © 2021 Ivan Akulov. All rights reserved.
//

protocol NetworkWeatherManagerDelegate: AnyObject {
    func updateInterface(_: NetworkWeatherManager, with currentWeather: CurrentWeather )
}

import Foundation

class NetworkWeatherManager {
    
    weak var delegate: NetworkWeatherManagerDelegate?
    
    func fetchCurrentWeather(forCity city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(with: data) {
                    self.delegate?.updateInterface(self, with: currentWeather)
                }
            }
        }.resume()
    }
    
    func parseJSON(with data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch {
            print(error)
        }
        return nil
    }
}
