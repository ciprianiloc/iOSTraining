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
    //var homeVC = HomeViewController()
    
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
            //get RANDOM Joke and category of joke
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")!
                let categoryResult = jsonObj?.value(forKeyPath: "value.categories") as! [String]
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let joke = Joke(context: context)
                
                joke.jokeDescription = jsonResult as? String
                //self.homeVC.jokeLabel.text? = (jsonResult as? String)!
                
                if categoryResult == []{
                        joke.jokeCategory = "Unknown"
                }else{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    joke.jokeCategory = String(describing: auxCategory)
                }
                
                //  joke.jokeCategory = categoryResult as? String

                
              //  if !self.jokesArray.contains(jsonResult as! String){
                    //self.jokesArray.append(jsonResult as! String)
               // }
//                
//                
//                if categoryResult.count >= 1{
//                    if !self.jokeCategoryArray.contains(String(describing: categoryResult)){
//                        var auxCategory = String(describing: categoryResult)
//                        auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
//                        auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
//                        auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
//                        self.jokeCategoryArray.append(String(describing: auxCategory))
//                        self.alljokesCategory.selectedCategory = auxCategory
//                    }
//                }
//                else{
//                    if !self.jokeCategoryArray.contains("Unknown"){
//                        self.jokeCategoryArray.append("Unknown")
//                        self.alljokesCategory.selectedCategory = "Unknown"
//                    }
//                }
                
               // self.jokesArray.append(jsonResult as! Joke)
                
//                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                
//                let joke = Joke(context: context)
//                
//                joke.jokeDescription = String(describing: jsonObj)
//                joke.jokeCategory = String(describing: categoryResult)
//                
//                
//                (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                
//            
                   (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
                
            
                
                OperationQueue.main.addOperation({
                    self.showJokes()
                })
                
                
            }
        }).resume()
    }
    
    func showJokes(){
                //for joke in jokesArray{
                    //print(jokesArray)
               // }
        //jokeLabel.text = jokesArray.last
    }


}




