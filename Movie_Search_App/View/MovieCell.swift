//
//  MovieCell.swift
//  Movie_Search_App
//
//  Created by Aaron Phan on 26/6/2023.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleBubble: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var releaseDateBubble: UIView!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
