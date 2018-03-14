//
//  MovieDetailViewController.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 14/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class MovieDetailViewController: UIViewController {
	
	// Models
	var arrMovieDetail:MovieDetail?
	
	// variables and constants
	var movieID:Int?
	

	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var imgMovie: UIImageView!
	@IBOutlet weak var lbReleaseDate: UILabel!
	@IBOutlet weak var lbOverview: UILabel!
	@IBOutlet weak var lbPopularity: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print(movieID!)
		getMovieDetail()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	fileprivate func getMovieDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString = KBaseUrl + KMovies + "\(self.movieID!)?api_key=" + KAPIKey + "&language=en-US"
			Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
				.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
					print("Progress: \(progress.fractionCompleted)")
				}
				.validate { request, response, data in
					return .success
				}
				.responseJSON { response in
					debugPrint(response)

					SVProgressHUD.dismiss()
					if	response.result.value == nil {
						let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertControllerStyle.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						return
					}
					
					if response.response!.statusCode == 200 {
						
						print("Success")
						let JSON:NSDictionary = (response.result.value as! NSDictionary?)!
						//print(JSON)
						//print(JSON["budget"]!)
						self.lbTitle.text = JSON["title"] as? String
						self.lbOverview.text = JSON["overview"] as? String
						if JSON["poster_path"] != nil {

							let img = KImageBaseUrl + "\(JSON["poster_path"]!)"
							let url = URL(string: img)
							DispatchQueue.global(qos: .userInitiated).async {
								let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
								DispatchQueue.main.async {
									self.imgMovie.image = UIImage(data: data!)
								}
							}
						}
						self.lbReleaseDate.text = "Released Date: \(JSON["release_date"]!)"
						self.lbPopularity.text = "Popularity: \(JSON["popularity"]!)"
						/*
						if let JSON:NSDictionary = response.result.value as! NSDictionary? {
							//self.arrJobs = []
							self.arrMovieDetail = response.result.value as! NSDictionary
							for dictionary in JSON["results"] as! NSArray{
								let job:MovieDetail = MovieDetail(dictionary: dictionary as! NSDictionary)
								self.arrMovieDetail.append(job)
							}
							
							//self.tableView.reloadData()
							
						}
						*/
						
						
						//result
						
					}else if response.response!.statusCode == 401{
						
						//print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KInvalidKey, preferredStyle: UIAlertControllerStyle.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else if response.response!.statusCode == 404{
						
						//print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KNoResourceFound, preferredStyle: UIAlertControllerStyle.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else{
						
						//print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KUnknown, preferredStyle: UIAlertControllerStyle.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}
					
			}
		}else{
			let alert = UIAlertController(title: "Network", message: KNoNetwork, preferredStyle: UIAlertControllerStyle.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}

}
