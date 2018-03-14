//
//  MovieListTableViewCell.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 13/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

	@IBOutlet weak var imgMoviePoster: UIImageView!
	@IBOutlet weak var lbMovieTitle: UILabel!
	@IBOutlet weak var lbMovieReleaseDate: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
