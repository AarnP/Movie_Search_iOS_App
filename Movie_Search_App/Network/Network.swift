//
//  Network.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 24/6/2023.
//

import Foundation


struct Network {
    
    static func loadMovies(_ completion: @escaping (_ success: Bool, _ data: [Movie]?) -> Void){
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwYmE5MDdhZWM2ODhiMGY0OGYxOTVkMDc1ZWM2MjI0OCIsInN1YiI6IjY0OTUwZTIzYTI4NGViMDBjNWJkMTdkYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ngMZnPp0Mmw5aaTSVDpE7ErbMcq8ci930bdadqyo9JQ"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        completion(true, res.results)
                    } catch let error {
                        print(error)
                        completion(false, nil)
                    }
                }
            }
        })
        dataTask.resume()
    }
}
