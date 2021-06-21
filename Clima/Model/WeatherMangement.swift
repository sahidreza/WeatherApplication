//
//  WeatherMangement.swift
//  Clima
//
//  Created by Sahid Reza on 17/06/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    
    func didUpdate(_ weatherManager:WeatherMangement,weather: WeatherModel)
    func didFaildwithError(error:Error)
    
}

struct WeatherMangement {
    
    var delegate:WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=b969997e372cb682d7681727f8dcb42e&units=metric"
    
    
    func fetchWeather(cityName:String){
        
        let urlString = weatherUrl + "&q=\(cityName)"
        print(urlString,"sss")
        perfromRequest(with: urlString)
        
        
    }
    
    func fetchWeather(latitude:CLLocationDegrees,lognitude:CLLocationDegrees){
        
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(lognitude)"
        perfromRequest(with: urlString)
        
    }
    
    func perfromRequest(with urlString:String){
        
        if let url = URL(string: urlString){
            
            let sesion = URLSession(configuration: .default)
            let task = sesion.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFaildwithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if  let weather = self.phaeseJson(safeData){
                        
                        delegate?.didUpdate(self, weather: weather)
                        
                        
                    }
                }
                
            }
            task.resume()
            
            
        }
        
        
        
    }
    
    func phaeseJson(_ weatherData:Data) -> WeatherModel? {
        
        let jsonDecoder = JSONDecoder()
        
        do {
            
            let decodeData = try jsonDecoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            let weather = WeatherModel(conditionID: id, cityName: name, temprature: temp)
            print(weather.tempatureString)
            return weather
            
            
        } catch let error{
            
            delegate?.didFaildwithError(error: error)
            return nil
        }
        
        
        
    }
    
    
    
}


