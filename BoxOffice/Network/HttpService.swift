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
    class func getJSON(_ url: String, callback:@escaping (Data) -> Void){
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
}
