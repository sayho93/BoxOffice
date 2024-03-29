//
//  Movie.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation

class SingletonInstance{
    static let instance = SingletonInstance()
    
    private var info = [String: Any]()
    
    func setInfo(_ key: String, _ value: Any){
        info[key] = value
    }
    func getInfo(_ key: String) -> Any?{
        return info[key]
    }
    
    func reInit(){
        info.removeAll()
    }
}

struct MovieList: Codable{
    let orderType: Int
    let movies: [Movie]
    enum CodingKeys: String, CodingKey{
        case orderType = "order_type"
        case movies
    }
}

struct Movie: Codable{
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var infoForTable: String{
        return "평점 : \(self.userRating) 예매순위 : \(self.reservationGrade) 예매율 : \(self.reservationRate)"
    }
    
    var infoForCollection: String{
        return "\(reservationGrade)위(\(userRating)) / \(reservationRate)"
    }
    
    enum CodingKeys: String, CodingKey{
        case userRating = "user_rating"
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case grade, thumb, id, title, date
    }
}

struct MovieDetail: Codable{
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    enum CodingKeys: String, CodingKey{
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
    }
}

struct CommentList: Codable{
    let comments: [Comment]
}

struct Comment: Codable{
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    let id: String
    enum CodingKeys: String, CodingKey{
        case movieId = "movie_id"
        case rating, timestamp, writer, contents, id
    }
}
