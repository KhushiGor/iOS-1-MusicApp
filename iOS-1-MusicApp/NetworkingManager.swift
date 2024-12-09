//
//  NetworkingManager.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//
protocol NetworkingDelegate {
    func networkingDidFinishWithListOfSongs(songs : [String])
    func networkingDidFinishWithSongObj(so : SongInfo)
    func networkingDidFail()
}
import Foundation
import UIKit
class NetworkingManager {
    static var shared = NetworkingManager()
   var delegate : NetworkingDelegate?
   
   var notificationName = (UIApplication.shared.delegate as! AppDelegate).notificationName

   
   // Option 3: pass the Result Type via completion handler
   func getSongsFromAPI(song: String,
                         completionHandler : @escaping (Result<[String], Error>)->Void) {
       // my code run in a different thread - not in main thread
       
       let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?&q=\(song)")
       
       let datatask = URLSession.shared.dataTask(with: url!) { data, response, error in
           if let error = error {// handle, then...return}
                              print(error)
                               
                           completionHandler(.failure(error))
                              return
                      }
           guard let httpResponse =
                              response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
                      else {
                          // no good response
                          // completionHandler(.failure(nil))
                           
                          return
                      }
           
           if let goodData = data {
               
               let decoder = JSONDecoder()
               do {
                   let songsList = try decoder.decode([String].self, from: goodData)
                   completionHandler(.success(songsList))
                   
                   
                   
               }catch {
                   print(error)
                   
               }
           }
       }
   datatask.resume()
       
   }

   
//    // Option 2: pass the list of string via completion handler
//    func getCitiesFromAPI(city: String, completionHandler : @escaping ([String])->Void) {
//        // my code run in a different thread - not in main thread
//
//        let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?&q=\(city)")
//
//        let datatask = URLSession.shared.dataTask(with: url!) { data, response, error in
//            if let error = error {// handle, then...return}
//                               print(error)
//
//                               return
//                       }
//            guard let httpResponse =
//                               response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
//                       else {
//                           // no good response
//
//                           return
//                       }
//
//            if let goodData = data {
//
//                let decoder = JSONDecoder()
//                do {
//                    let citiesList = try decoder.decode([String].self, from: goodData)
//                    completionHandler(citiesList)
//
//
//                }catch {
//                    print(error)
//
//                }
//            }
//        }
//    datatask.resume()
//
//    }
//
   
   // option 1: send list of cities to view controller using Delegate Protocol
   
//    func getCitiesFromAPI(city: String) {
//        // my code run in a different thread - not in main thread
//
//        let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?&q=\(city)")
//
//        let datatask = URLSession.shared.dataTask(with: url!) { data, response, error in
//            if let error = error {// handle, then...return}
//                               print(error)
//                                self.delegate?.networkingDidFail()
//                               return
//                       }
//            guard let httpResponse =
//                               response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
//                       else {
//                           // no good response
//                            self.delegate?.networkingDidFail()
//                           return
//                       }
//
//            if let goodData = data {
//
//                let decoder = JSONDecoder()
//                do {
//                    let citiesList = try decoder.decode([String].self, from: goodData)
//
//                    self.delegate?.networkingDidFinishWithListOfCities(cities:citiesList)
//                }catch {
//                    print(error)
//
//                }
//            }
//        }
//    datatask.resume()
//
//    }
//
   
//
//    func getWeather(city: String) {
//        // my code run in a different thread - not in main thread
//
//        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=071c3ffca10be01d334505630d2c1a9c&units=metric")
//
//        let datatask = URLSession.shared.dataTask(with: url!) { data, response, error in
//            if let error = error {// handle, then...return}
//                               print(error)
//                                self.delegate?.networkingDidFail()
//                               return
//                       }
//            guard let httpResponse =
//                               response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
//                       else {
//
//                           // no good response
//                            self.delegate?.networkingDidFail()
//                           return
//                       }
//
//            if let goodData = data {
//
//                let decoder = JSONDecoder()
//                do {
//                    let weatherObj = try decoder.decode(WeatherModel.self, from: goodData)
//                    self.delegate?.networkingDidFinishWithWeatherObj(wo: weatherObj)
//
//
//                }catch {
//                    print(error)
//
//                }
//            }
//        }
//    datatask.resume()
//
//    }
//
   
   
   // option 4 - send a local notification
   func getSong(song: String) {
       // my code run in a different thread - not in main thread
       
       let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(song)&appid=071c3ffca10be01d334505630d2c1a9c&units=metric")
       
       let datatask = URLSession.shared.dataTask(with: url!) { data, response, error in
           if let error = error {// handle, then...return}
                              print(error)
                               self.delegate?.networkingDidFail()
                              return
                      }
           guard let httpResponse =
                              response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
                      else {
                      
                          // no good response
                          return
                      }
           
           if let goodData = data {
               
               let decoder = JSONDecoder()
               do {
                   
                  var dic = try JSONSerialization.jsonObject(with: goodData) as! NSDictionary
                   
                   
                   var songArray = dic["song"] as! NSArray
                   let firstObjInArray = songArray[0] as! NSDictionary
                   print(firstObjInArray["icon"])
                   print(firstObjInArray["description"])
                   
                   
                   
                  
                   
                   let songObj = try decoder.decode(SongInfo.self, from: goodData)
                   NotificationCenter.default.post(name: Notification.Name(self.notificationName), object: nil, userInfo: ["songObj": songObj])
                   
                   
                   
               }catch {
                   print(error)
                   
               }
           }
       }
   datatask.resume()
       
   }
   
}

