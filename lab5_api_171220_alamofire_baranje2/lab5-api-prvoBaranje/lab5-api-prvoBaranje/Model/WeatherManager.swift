
import Foundation
import CoreLocation
import Alamofire

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=39ff4d73a052699c5118dea6ce42b7fe&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            AF.request(url).validate().responseDecodable(of: WeatherData.self, completionHandler: { response in
                guard let weather = response.value else { return }
                self.delegate?.didUpdateWeather(self, weather: self.parseJSON(weather)!)
            })
            
        }
    }
    
    func parseJSON(_ weatherData: WeatherData) -> WeatherModel? {
            let id = weatherData.weather[0].id
            let temp = weatherData.main.temp
            let name = weatherData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
       
    }
    
    
    
}


