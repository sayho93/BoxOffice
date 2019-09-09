//
//  Movie.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation

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
    
    enum CodingKeys: String, CodingKey{
        case userRating = "user_rating"
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case grade, thumb, id, title, date
    }
}
