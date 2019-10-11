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
                callback(data ?? Data())
            }
            session.invalidateAndCancel()
        })
        task.resume()
    }
    
    class func post(_ url: String, _ params: Data, callback: @escaping(HTTPURLResponse, Data) -> Void){
        guard let nsUrl = URL(string: url) else{return}
        var request = URLRequest(url: nsUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = params
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("http error")
            }
            if let res = response as? HTTPURLResponse{
                if let retData = data{
                    callback(res, retData)
                }
            }
            session.invalidateAndCancel()
        }
        task.resume()
    }
    
    class func makePostParam(params: [String: Any]) -> Data{
        do{
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            return data
        }catch(let err){
            print(err.localizedDescription)
        }
        return Data()
    }
    
    class func parseJSONFromData(_ jsonData: Data?) -> [String : Any]?{
      if let data = jsonData {
        do {
          let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
          return jsonDictionary
        } catch let error as NSError {
          print("error processing json data: \(error.localizedDescription)")
        }
      }
      return nil
    }
}
