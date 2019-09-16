//
//  Config.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation

struct Config{
    static let API_BASE_URL: String = "https://connect-boxoffice.run.goorm.io/"
    static let MOVIE_LIST_URL: String = API_BASE_URL + "/movies"
    static let ORDER_TYPE_PARAMETER: String = "?order_type="
    static let MOVIE_URL: String = API_BASE_URL + "/movie"
    
}

extension Notification {
    static let DidReceiveMovieList = Notification.Name("DidReceiveMovieList")
    static let DidReceiveMovieDetail = Notification.Name("DidReceiveMovieDetail")
}
