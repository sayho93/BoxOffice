//
//  Config.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation
import UIKit

struct Config{
    struct colors{
        static let themeColor: UIColor = UIColor(red: 80.0/255.0, green: 110.0/255.0, blue: 200.0/255.0, alpha: 0.5)
    }
    static let API_BASE_URL: String = "https://connect-boxoffice.run.goorm.io"
    static let MOVIE_LIST_URL: String = API_BASE_URL + "/movies"
    static let ORDER_TYPE_PARAMETER: String = "?order_type="
    static let MOVIE_URL: String = API_BASE_URL + "/movie"
    static let COMMENT_LIST_URL: String = API_BASE_URL + "/comments"
    static let COMMENT_LIST_PARAMETER: String = "?movie_id="
    static let COMMENT_WRITE_URL: String = API_BASE_URL + "/comment"
}

extension Notification {
    static let DidReceiveMovieList = Notification.Name("DidReceiveMovieList")
    static let DidReceiveMovieDetail = Notification.Name("DidReceiveMovieDetail")
    static let DidReceiveCommentList = Notification.Name("DidReceiveCommentList")
    static let DidReceiveCommentRefresh = Notification.Name("DidReceiveCommentRefresh")
}
