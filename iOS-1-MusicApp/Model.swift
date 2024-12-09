//
//  Model.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//

import Foundation

class SongInfo : Decodable{
    var songname : String
    var songImage : String
    init(songname: String, songImage: String) {
        self.songname = songname
        self.songImage = songImage
    }
}
