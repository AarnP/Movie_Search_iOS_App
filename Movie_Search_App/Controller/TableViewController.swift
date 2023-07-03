//
//  TableViewController.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 24/6/2023.
//

import UIKit

class TableViewController: UIViewController {
    var movies: [Movie] = []
    var poster: [UIImage] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        Network.loadMovies { success,data in
            if let data {
                self.movies = data
                print("debug-- Network.loadMovies = \(self.movies[0])")
            } else {
                print("Network request failed")
            }
        }
        
    }
}
    // MARK: - Table view data source
    
    extension TableViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ReusableCell",
                for: indexPath
            ) as! MovieCell
            
            cell.movieTitle.text = self.movies[indexPath.row].title
            cell.releaseDate.text = self.movies[indexPath.row].releaseDate
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "goToMovieDetail", sender: indexPath)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            if let destinationVC = segue.destination as? MovieDetailViewController, let indexPath = sender as? IndexPath {
                destinationVC.movieData = movies[indexPath.row]
            }
        }
    }



    
     
            
    // MARK: - Update Movie List
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     if segue.identifier == "goToMovieDetail" {
     let destinationVC = segue.destination as! MovieDetailViewController
     destinationVC.movieTitle
    }
    */

