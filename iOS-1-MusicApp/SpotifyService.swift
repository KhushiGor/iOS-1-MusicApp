//
//  SpotifyService.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//
import Foundation
class SpotifyService {
    private let baseURL = "https://spotify23.p.rapidapi.com/tracks/"
    private let apiKey = "ed98d2fc93msh30dab0bc53ad12bp100f92jsnaeaea898ba37"

    func fetchTracks(ids: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)?ids=\(ids)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        request.addValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.addValue("spotify23.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                completion(.success(data))
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                completion(.failure(NSError(domain: "API Error", code: statusCode, userInfo: nil)))
            }
        }

        dataTask.resume()
    }
}
