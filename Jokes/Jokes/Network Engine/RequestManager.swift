//
//  RequestManager.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation




class RequestManager: NSObject {

    
    let URLApi = "http://api.icndb.com/jokes/random"
    var jokesArray = [Joke]()
    //var homeVCJokeLabel = ""
    
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
            //get RANDOM Joke and category of joke
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")! //get random joke
                let categoryResult = jsonObj?.value(forKeyPath: "value.categories") as! [String] //get joke category
                
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let joke = Joke(context: context)
                joke.jokeDescription = jsonResult as? String
                //self.homeVCJokeLabel = String(describing: jsonResult)
                
                if categoryResult == []{
                        joke.jokeCategory = "Unknown"
                }else{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    joke.jokeCategory = String(describing: auxCategory)
                    
                    
//                    let random = Int64(Int(arc4random_uniform(6)))
//                    let cosmos = CosmosView()
//                    
////                        if random > 0 {
////                        joke.jokeRating = random
////                       
////                        }else{
////                            joke.jokeRating = 1
////                        }
//                        cosmos.rating = Double(joke.jokeRating)
//                    
//                    }
//                
                    
                }
                
                
                
                   (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
                
                
               
                let homeSB = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = homeSB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                homeVC?.selectedJokeLabel = joke.jokeDescription
                
            }
            
            
        }).resume()
        
        
    }
    



}
var mainRequest = RequestManager()



