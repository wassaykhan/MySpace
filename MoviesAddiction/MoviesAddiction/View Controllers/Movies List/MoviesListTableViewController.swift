//
//  MoviesListTableViewController.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 13/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MoviesListTableViewController: UITableViewController,MinMaxProtocol {
	// Models
	var arrMovies:Array<MovieData> = []
	
	
	
	// variables and constants
	var isLoadingList:Bool = false
	var minYear:String = "2000-09-29"
	var maxYear:String = "2018-11-29"
	var movieID:Int = 20
	let filterType:String = "popularity.desc"
	let page:String = "1"
	let rowHeight:CGFloat = 150
	
	var valueSentFromSecondViewController:String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		print("Loaded")
//		if let valueToDisplay = valueSentFromSecondViewController {
//			print("Value from display = \(self.minYear)")
//		}
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		getMoviesList()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		setResultOfBusinessLogic(valueSent: "yes")
	}
	
	func setResultOfBusinessLogic(valueSent: String){
		self.tableView.reloadData()
	}
	
	fileprivate func getMoviesList() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString = KBaseUrl + KDiscoverMovies + "api_key=" + KAPIKey + "&primary_release_date.gte=" + minYear + "&primary_release_date.lte=" + maxYear + "&sort_by=" + filterType// + "&page=" + page
			Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default)
				.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
					print("Progress: \(progress.fractionCompleted)")
				}
				.validate { request, response, data in
					// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
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
						if let JSON:NSDictionary = response.result.value as! NSDictionary? {
							self.arrMovies = []
							for dictionary in JSON["results"] as! NSArray{
								let job:MovieData = MovieData(dictionary: dictionary as! NSDictionary)
								self.arrMovies.append(job)
							}
							//self.isLoadingList = false
							self.tableView.reloadData()
							
						}
						
					}else if response.response!.statusCode == 401{
						
						print("Server Error")
						let alert = UIAlertController(title: "ALert", message: KInvalidKey, preferredStyle: UIAlertControllerStyle.alert)
						let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
						alert.addAction(defaultAction)
						self.present(alert, animated: true, completion: nil)
						
					}else if response.response!.statusCode == 404{
						
						print("Server Error")
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
	
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrMovies.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		let data:MovieData = self.arrMovies[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellIdentifier", for: indexPath) as! MovieListTableViewCell
		if data.posterPath != nil {
			
			//let url = URL(string: image.url)
			let img = KImageBaseUrl + data.posterPath!
			let url = URL(string: img)
			DispatchQueue.global(qos: .userInitiated).async {
				let data = try? Data(contentsOf: url!)
				DispatchQueue.main.async {
					cell.imgMoviePoster.image = UIImage(data: data!)
				}
			}
		}
		
		cell.lbMovieTitle.text = data.originalTitle
		cell.lbMovieReleaseDate.text = "Release Date: " + data.releaseDate!


        return cell
    }
    

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return rowHeight
	}
	
	@IBAction func btnFilter(_ sender: Any) {
		
		let alertController = UIAlertController(title: "Add Max Min Date", message: "", preferredStyle: .alert)
		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Max Year YYYY-MM-DD"
		}
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
			let maxYearInput = alertController.textFields![0] as UITextField
			let minYearInput = alertController.textFields![1] as UITextField
			
			let dateFormatterGet = DateFormatter()
			dateFormatterGet.dateFormat = "yyyy-MM-dd"
			if dateFormatterGet.date(from: maxYearInput.text!) != nil {
				print("Valid Date")
			} else {
				print("invalid format")
			}
			
			if maxYearInput.text != "" && dateFormatterGet.date(from: maxYearInput.text!) != nil  {
				self.maxYear = maxYearInput.text!
			}
			if minYearInput.text != "" && dateFormatterGet.date(from: minYearInput.text!) != nil{
				self.minYear = minYearInput.text!
			}
			self.getMoviesList()
			
			print("firstName \(String(describing: maxYearInput.text)), secondName \(String(describing: minYearInput.text))")
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })
		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Min Year YYYY-MM-DD"
		}
		
		alertController.addAction(saveAction)
		alertController.addAction(cancelAction)
		
		self.present(alertController, animated: true, completion: nil)
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Row Selected")
	}
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "movieDetailIdentifier") {
			let indexPath = self.tableView!.indexPathForSelectedRow!
			let idMovie = self.arrMovies[indexPath.row]
			self.movieID = idMovie.movieId!
			let viewController = segue.destination as! MovieDetailViewController
			viewController.movieID = self.movieID
		}
    }
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !self.isLoadingList ){
			//self.isLoadingList = true
			print("end")
			//self.getMoviesList()
//			self. isLoadingList = true
//			self. loadMoreItemsForList()
		}
	}
	

}
