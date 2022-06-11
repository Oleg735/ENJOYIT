//
//  Model.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 27.07.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String?
    //var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
    var trackViewUrl: String?
    var previewUrl: String?
    var kind: String?
    var releaseDate: String?
}
