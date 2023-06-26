//
//  MoviePoster.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 25/6/2023.
//

import Foundation

struct MoviePoster {
    let movieURL = "https://image.tmdb.org/t/p/w185"
    
    func fetchMoviePoster(posterPath: String) {
        let posterURLString = "\(movieURL)\(posterPath)"
    }
}
