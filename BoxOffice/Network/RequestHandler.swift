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

        HttpService.get(url){ (data) -> Void in
            do{
                let apiResponse: MovieList = try! JSONDecoder().decode(MovieList.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveMovieList, object: nil, userInfo: ["data": apiResponse.movies])
            }
        }
    }
    //---------------------------------------
    
    class func getMovieList(type: Int = 0, callback: @escaping (() -> Void)){
        let url = Config.MOVIE_LIST_URL + Config.ORDER_TYPE_PARAMETER + String(type)
        HttpService.get(url){ (data) -> Void in
            do{
                let apiResponse: MovieList = try JSONDecoder().decode(MovieList.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveMovieList, object: nil, userInfo: ["data": apiResponse.movies])
                callback()
            }catch(let err){
                print(err.localizedDescription)
            }
        }
    }
    
    class func getMovieDetail(id: String, callback: @escaping (() -> Void)){
        let url = Config.MOVIE_URL + "?id=\(id)"
        
        HttpService.get(url){ (data) -> Void in
            do{
                let apiResponse: MovieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveMovieDetail, object: nil, userInfo: ["data": apiResponse])
                callback()
            }catch(let err){
                print(err.localizedDescription)
            }
        }
    }
    
    class func getCommentList(id: String, callback: @escaping(() -> Void)){
        let url = Config.COMMENT_LIST_URL + Config.COMMENT_LIST_PARAMETER + id
        HttpService.get(url) { (data) -> Void in
            do{
                let apiResponse: CommentList = try JSONDecoder().decode(CommentList.self, from: data)
                NotificationCenter.default.post(name: Notification.DidReceiveCommentList, object: nil, userInfo: ["data": apiResponse.comments])
                callback()
            }catch(let err){
                print(err.localizedDescription)
            }
        }
    }
    
    class func saveComment(movieID: String, userName: String, comment: String, rating: Int, callback: @escaping((Int) -> Void)){
        let url = Config.COMMENT_WRITE_URL
        var params = [String: Any]()
        params["rating"] = Double(rating)
        params["writer"] = userName
        params["movie_id"] = movieID
        params["contents"] = comment
        let requestParam = HttpService.makePostParam(params: params)
        
        HttpService.post(url, requestParam) { (response, data) in
            if response.statusCode == 200{
                callback(1)
            }else{
                callback(-1)
            }
        }
    }
}
