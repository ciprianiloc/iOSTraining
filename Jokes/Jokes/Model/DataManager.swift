//
//  DataManager.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation

let topJokeURL = "http://api.icndb.com"

class DataManager: NSObject {
    
    func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let loadDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil, error)
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    let statusError = NSError(domain: "com.raywenderlich",
                                              code: response.statusCode,
                                              userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
                    completion(nil, statusError)
                } else {
                    completion(data, nil)
                }
            }
        }
        loadDataTask.resume()
    }
    
    func getJokesFromURL(success: @escaping ((_ jokesData: Data) -> Void)){
        loadDataFromURL(url: URL(string: topJokeURL)!){
            (data,error) -> Void in
            
            if let data = data {
                success(data)
            }
        }
    }
}


