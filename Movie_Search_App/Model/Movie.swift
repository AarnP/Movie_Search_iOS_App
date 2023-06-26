//
//  Movie.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 24/6/2023.
//

import Foundation

struct Movie : Codable {
    let title : String
    let posterPath : String
    let releaseDate : String
    let overview : String
    let moviePosterURL = "https://image.tmdb.org/t/p/w185"
    
    init(title: String, posterPath: String, releaseDate: String, overview: String) {
        self.title = title
        self.posterPath = "\(moviePosterURL)\(posterPath)"
        self.releaseDate = releaseDate
        self.overview = overview
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview
    }
    
}

struct Response: Codable {
    let page: Int
    let results: [Movie]
}
