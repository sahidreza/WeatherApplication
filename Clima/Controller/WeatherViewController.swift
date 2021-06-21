//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherMangement = WeatherMangement()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherMangement.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
    
}


//MARK: - UITextField Delegate

extension WeatherViewController:UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!,"textFieldValue")
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            
            weatherMangement.fetchWeather(cityName: city)
        }
        
        
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != ""{
            
            
            return true
        }
        else {
            
            textField.placeholder = "Plase write something"
            return false
        }
    }
    
}



//MARK: - Weather manager Deleggate

extension WeatherViewController:WeatherManagerDelegate{
    
    
    
    func didUpdate(_ weatherManager:WeatherMangement,weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.temperatureLabel.text =  weather.tempatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            
        }
        
    }
    
    func didFaildwithError(error: Error) {
        
        print("error")
    }
    
    
    
}

//MARK: - CDLocation Manger Delegate

extension WeatherViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let locattion = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = locattion.coordinate.latitude
            let lon = locattion.coordinate.longitude
            weatherMangement.fetchWeather(latitude: lat, lognitude: lon)
          
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }

}

