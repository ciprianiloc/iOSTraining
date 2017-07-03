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
    var categories : [JokeCategory] = [JokeCategory]()
    
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
            //get RANDOM Joke and category of joke
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")! //get random joke
                let categoryResult = jsonObj?.value(forKeyPath: "value.categories") as! [String] //get joke category
                
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let joke = Joke(context: context)
              
                let category = JokeCategory(context: context)
                
                var jokeWihQuote = jsonResult as! String
                if jokeWihQuote.contains("&quot;"){
                    jokeWihQuote = jokeWihQuote.replacingOccurrences(of: "&quot;", with: "\'")
                }
                
                
                
                joke.jokeDescription = jokeWihQuote
                               
                if categoryResult == []{
                        joke.jokeCategory = "Unknown"
                    
                    category.categoryName = "Unknown"
                    
                    if  !self.categories.contains(where: {$0.categoryName == "Unknown"}){
                        self.categories.append(category)
                    }
                    
                    
                }else{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    joke.jokeCategory = String(describing: auxCategory)
                    category.categoryName = String(describing: auxCategory)
                
                    if  !self.categories.contains(where: {$0.categoryName == auxCategory}){
                        self.categories.append(category)
                    }
                    
                }
                
             //   print(self.categories)
                
                
                let randomJokeRating = Double(arc4random_uniform(6))
                
                if randomJokeRating > 0 {
                    joke.jokeRating = randomJokeRating
                }else{
                    joke.jokeRating = 1
                }
                
                
                let addJokeSB = UIStoryboard(name: "AllJokes", bundle: nil)
                let addJokeVC = addJokeSB.instantiateViewController(withIdentifier: "AddNewJokeViewController") as? AddNewJokeViewController
                addJokeVC?.pickerData  = self.categories
                
                
                //joke.jokeRating =  //assign random rating when making a joke request - jokes from API do not have rating
                
                   (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
                
                
               
                let homeSB = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = homeSB.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                homeVC?.selectedJokeLabel = joke.jokeDescription
                
                
                
                
            }
            
            
        }).resume()
        
        
    }
    



}
var mainRequest = RequestManager()



