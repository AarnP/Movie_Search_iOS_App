//
//  Movie.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 24/6/2023.
//

import Foundation

struct Movie : Codable {
    let title: String
    let posterPath: String
    
    init(title: String, posterPath: String) {
        self.title = title
        self.posterPath = posterPath
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
    }
}

struct Response: Codable {
    let page: Int
    let results: [Movie]
}
