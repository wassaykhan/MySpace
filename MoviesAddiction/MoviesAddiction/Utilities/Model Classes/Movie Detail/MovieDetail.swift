//
//  MovieDetail.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 14/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit

class MovieDetail: NSObject {

	var movieId:Int?
	var title:String?
	var posterPath:String?
	var originalTitle:String?
	var adult:Bool?
	var overview:String?
	var releaseDate:String?
	var budget:Int?
	var homepage:String?
	var popularity:Int?
	
	init(dictionary:NSDictionary) {
		self.movieId = dictionary["id"] as? Int
		self.title = dictionary["title"] as? String
		self.posterPath = dictionary["poster_path"] as? String
		self.originalTitle = dictionary["original_title"] as? String
		self.adult = dictionary["adult"] as? Bool
		self.overview = dictionary["overview"] as? String
		self.releaseDate = dictionary["release_date"] as? String
		self.budget = dictionary["budget"] as? Int
		self.homepage = dictionary["homepage"] as? String
		self.popularity = dictionary["popularity"] as? Int
	}
	
}
