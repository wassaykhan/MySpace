//
//  MovieData.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 13/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit

class MovieData: NSObject {

	var movieId:Int?
	var title:String?
	var posterPath:String?
	var originalTitle:String?
	var adult:Bool?
	var overview:String?
	var releaseDate:String?
	
	init(dictionary:NSDictionary) {
		self.movieId = dictionary["id"] as? Int
		self.title = dictionary["title"] as? String
		self.posterPath = dictionary["poster_path"] as? String
		self.originalTitle = dictionary["original_title"] as? String
		self.adult = dictionary["adult"] as? Bool
		self.overview = dictionary["overview"] as? String
		self.releaseDate = dictionary["release_date"] as? String
	}
	
}
