//
//  HttpService.swift
//  BoxOffice
//
//  Created by 전세호 on 06/09/2019.
//  Copyright © 2019 sayho. All rights reserved.
//

import Foundation
import UIKit

class HttpService {
    class func get(_ url: String, callback: @escaping(Data) -> Void){
        guard let nsUrl = URL(string: url) else{return}
        let session = URLSession.shared
        let task = session.dataTask(with: nsUrl, completionHandler: { (data, response, error) -> Void in
            if error != nil{
                print("http error")
            }
            if data != nil{
//                guard let tmpData = data else{return}
//                guard let jsonData = try? JSONSerialization.jsonObject(with: tmpData, options: []) as? [String: Any] else{
//                    return
//                }
//                callback(jsonData)
                callback(data ?? Data())
            }
            session.invalidateAndCancel()
        })
        task.resume()
    }
    
    class func post(_ url: String, callback: @escaping(Data) -> Void){
        guard let nsUrl = URL(string: url) else{return}
        var request = URLRequest(url: nsUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body = "maintext=히브리서&jang=11&jeol=1&jeol2=10".data(using:String.Encoding.utf8, allowLossyConversion: false)
        request.httpBody = body
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("http error")
            }
            
            if let res = response{
                print(res)
            }
            
            if let data = data {
                callback(data)
            }
            session.invalidateAndCancel()
        }
        task.resume()
    }
}
