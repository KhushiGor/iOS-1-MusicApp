//
//  SpotifyAPI.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-10.
//

import Foundation
class SpotifyAPI {
    
    static let shared = SpotifyAPI()
    private let baseURL = "https://api.spotify.com/v1/search"
    
    private init() {}
    
    // Function to search for songs by query
    func searchSongs(query: String, completion: @escaping (Result<[Song], Error>) -> Void) {
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid Query", code: 400, userInfo: nil)))
            return
        }
        
        let urlString = "\(baseURL)?q=\(encodedQuery)&type=track&limit=20"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer BQDu-zljj_Uev6lWQflDNkqUehhiLuUORblyHTgkJBBRnNHxo8D_cCFJ_v0TVJnYkviyHTsJKLcFuBrqUFOuR-Hh5uyhOWtyYxMk6bW9XoU7hWGpcJw", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
                let songs = decodedResponse.tracks.items.map { Song(id: $0.id, name: $0.name, artist: $0.artists.first?.name ?? "", thumbnailURL: $0.album.images.first?.url ?? "") }
                completion(.success(songs))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// Model to parse Spotify response
