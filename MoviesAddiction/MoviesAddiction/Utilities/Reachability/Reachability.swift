//
//  Reachability.swift
//  MoviesAddiction
//
//  Created by Wassay Khan on 13/03/2018.
//  Copyright © 2018 Wassay Khan. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class Reachability {
	class func isConnectedToInternet() ->Bool {
		return NetworkReachabilityManager()!.isReachable
	}
}

