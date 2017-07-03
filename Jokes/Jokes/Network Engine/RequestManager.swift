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
    var categories : [JokeCategory] = [JokeCategory]()
    var fetchedCategories : [JokeCategory] = [JokeCategory]()
    
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
                    
                    
                    
                        //fetch all categories and check if the new one exists
                             let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeCategory")
                            do{
                              self.fetchedCategories = try context.fetch(requestJoke) as! [JokeCategory]
                                
                                if !self.fetchedCategories.contains(category){
                                    print("NOT ADDED")
                                    category.categoryName = "Unknown"
                                }
                            }catch{
                                print("fetch failed for checking if new category")
                            }
                            
                    
                    
                }else{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    joke.jokeCategory = String(describing: auxCategory)
                    
                    
                    
                    let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeCategory")
                    do{
                        self.fetchedCategories = try context.fetch(requestJoke) as! [JokeCategory]
                        
                        if self.fetchedCategories.contains(category){
                            print("NOT added")
                            category.categoryName = String(describing: auxCategory)
                        }
                    }catch{
                        print("fetch failed for checking if new category")
                    }
                
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



