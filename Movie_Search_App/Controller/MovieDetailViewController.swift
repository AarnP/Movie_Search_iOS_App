//
//  ViewController.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 23/6/2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieData : Movie?

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if movieData != nil {
            movieTitle.text = movieData?.title
            overview.text = movieData?.overview
            releaseDate.text = movieData?.releaseDate
        }
    }


}

