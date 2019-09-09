//
//  Request.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation



class RequestHandler{
    //---------------------------------------sample
    class func getData(type: Int, callback: @escaping ((String) -> Void)){
        let url = Config.MOVIE_LIST_URL + Config.ORDER_TYPE_PARAMETER + String(type)

        HttpService.getJSON(url){ (data) -> Void in
            do{
                let apiResponse: MovieList = try! JSONDecoder().decode(MovieList.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveMovieList, object: nil, userInfo: ["data": apiResponse.movies])
            }
        }
    }
    //---------------------------------------
    
    class func getMovieList(type: Int = 0){
        let url = Config.MOVIE_LIST_URL + Config.ORDER_TYPE_PARAMETER + String(type)
        HttpService.getJSON(url){ (data) -> Void in
            do{
                let apiResponse: MovieList = try! JSONDecoder().decode(MovieList.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveMovieList, object: nil, userInfo: ["data": apiResponse.movies])
            }
        }
    }
}
