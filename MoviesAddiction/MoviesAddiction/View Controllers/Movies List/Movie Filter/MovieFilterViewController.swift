//
//  MovieFilterViewController.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 14/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import UIKit

protocol MinMaxProtocol {
	func setResultOfBusinessLogic(valueSent: String)
}

class MovieFilterViewController: UIViewController {

	var delegate:MinMaxProtocol?
	
	@IBOutlet weak var dateMax: UIDatePicker!
	@IBOutlet weak var dateMin: UIDatePicker!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//let firstName = "Sergey"
		//let lastName = "Kargopolov"
		//let fullName = firstName + " " + lastName
		
		//delegate?.setResultOfBusinessLogic(valueSent: fullName)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func btnClose(_ sender: Any) {
		delegate?.setResultOfBusinessLogic(valueSent: "fullName")
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func btnDone(_ sender: Any) {
		print("Max Date: " , dateMax.date )
		print("Min Date: " , dateMin.date )
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
