//
//  RequestManager.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation
import CoreData




class RequestManager: NSObject {

    
    let URLApi = "http://api.icndb.com/jokes/random"
    var jokesArray = [Joke]()
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
            //get RANDOM Joke and category of joke
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")! //get random joke
                let categoryResult = jsonObj?.value(forKeyPath: "value.categories") as! [String] //get joke category
                
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let joke = Joke(context: context)
               
              
                
                var jokeWithQuoteAndName = jsonResult as! String
                if jokeWithQuoteAndName.contains("&quot;"){
                    jokeWithQuoteAndName = jokeWithQuoteAndName.replacingOccurrences(of: "&quot;", with: "\'")
                }
                
                jokeWithQuoteAndName = jokeWithQuoteAndName.replacingOccurrences(of: "Chuck Norris", with: "Cristian Banarescu")
                
                joke.jokeDescription = jokeWithQuoteAndName
                               
                if categoryResult == []{
                        joke.jokeCategory = "Unknown"
                
                    //save category to CoreData if it does not exist yet
                    
                    
                }else{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    joke.jokeCategory = String(describing: auxCategory)
                }
                //joke.jokeRating =  //assign random rating when making a joke request - jokes from API do not have rating

                let randomJokeRating = Double(arc4random_uniform(6))
                
                if randomJokeRating > 0 {
                    joke.jokeRating = randomJokeRating
                }else{
                    joke.jokeRating = 1
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



