//
//  Model.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//

import Foundation
struct SpotifySearchResponse: Decodable {
    let tracks: TrackContainer
}

struct TrackContainer: Decodable {
    let items: [Track]
}

struct Track: Decodable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album
}

struct Artist: Decodable {
    let name: String
}

struct Album: Decodable {
    let images: [Image]
}

struct Image: Decodable {
    let url: String
}

// Song model to use within the app
struct Song {
    let id: String
    let name: String
    let artist: String
    let thumbnailURL: String
}
