//
//  TableViewController.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 24/6/2023.
//

import UIKit
import CoreData

class TableViewController: UIViewController {
    var movies: [Movie] = []
    var moviesDB: [MoviesData] = []
    var moviesFilterData: [Movie] = []
    
    var poster: [ImageData] = []
    var imageCache = NSCache<NSString, UIImage>()
    var posterURL: [String] = []
    var URLPath: String = ""
    var posterImage: UIImage?
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        Network.loadMovies { success,data in
            if let data {
                self.movies = data
                self.moviesFilterData = self.movies
                print("debug-- Network.loadMovies = \(self.movies[0])")
            } else {
                print("Network request failed")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovie()
        
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
                        
    }
    
    func getMoviePosterURL() {
        for movie in moviesFilterData {
            URLPath = "\(movie.moviePosterURL)\(movie.posterPath)"
            posterURL.append(URLPath)
        }
    }
    
    func saveMovie() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadMovie() {
        let request : NSFetchRequest<MoviesData> = MoviesData.fetchRequest()
        do {
            moviesDB = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        
    }
}
// MARK: - Table view data source

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesFilterData.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ReusableCell",
            for: indexPath
        ) as! MovieCell
        // GET FULL URL PATH FOR POSTER IMAGE
        getMoviePosterURL()
        
        let currentPosterPath = posterURL[indexPath.row]
        let currentPosterURLPath = URL(string: currentPosterPath)!
        
        cell.movieTitle.text = self.moviesFilterData[indexPath.row].title
        cell.releaseDate.text = self.moviesFilterData[indexPath.row].releaseDate
        
        
        let newMovieAdded = MoviesData(context: self.context)
        newMovieAdded.title = self.moviesFilterData[indexPath.row].title
        newMovieAdded.releaseDate = self.moviesFilterData[indexPath.row].releaseDate
        newMovieAdded.overview = self.moviesFilterData[indexPath.row].overview
        newMovieAdded.posterPath = self.moviesFilterData[indexPath.row].posterPath
        newMovieAdded.moviePosterURL = "\(self.moviesFilterData[indexPath.row].moviePosterURL)\(self.moviesFilterData[indexPath.row].posterPath)"
        self.saveMovie()

        
        // check if the image is already in the cache
        if let cachedImage = imageCache.object(forKey: currentPosterPath as NSString) {
            cell.moviePoster.image = cachedImage
            posterImage = cachedImage
        } else {
            //Download the image asynchronously
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: currentPosterURLPath),
                   let image = UIImage(data: data) {
                    //Store the download image in the cache
                    self.imageCache.setObject(image, forKey: currentPosterPath as NSString)
                    
                    //Update the UI on the main queue
                    DispatchQueue.main.async {
                        cell.moviePoster.image = image
                        self.posterImage = image
                    }
                    
                    // Save the image data to the file system for offline use
                    self.saveImageDataToDisk(data: data, imageURL: currentPosterURLPath)
                }
            }
        }
        
        
        return cell
    }
    
    
    
    
    func saveImageDataToDisk(data: Data, imageURL: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageURL.lastPathComponent)
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image data to disk: \(error)")
        }
    }
    
    func getImageDataFromDisk(imageURL: URL) -> Data? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(imageURL.lastPathComponent)
        
        return try? Data(contentsOf: fileURL)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToMovieDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? MovieDetailViewController, let indexPath = sender as? IndexPath {
            destinationVC.movieData = moviesFilterData[indexPath.row]
            
            let currentPosterPath = posterURL[indexPath.row]
            let currentPosterURLPath = URL(string: currentPosterPath)!
            let getImageData = getImageDataFromDisk(imageURL: currentPosterURLPath)
            destinationVC.posterData = getImageData
        }
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        moviesFilterData = []
        
        if searchText == "" {
            moviesFilterData = movies
        }
        
        for movie in movies {
            if movie.title.uppercased().contains(searchText.uppercased()) {
                moviesFilterData.append(movie)
            }
        }
        self.tableView.reloadData()
    }
}

