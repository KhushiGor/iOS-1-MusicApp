//
//  Model.swift
//  iOS-1-MusicApp
//
//  Created by Khushi Mineshkumar Gor on 2024-12-08.
//

import Foundation

class SongInfo : Decodable{
    var song : [songObj] = [songObj]()
}
class songObj : Decodable{
    var songname : String
    var songImage : String
    
}
