//
//  ViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 20/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{

    let URLApi = "http://api.icndb.com/jokes/random"
    var jokesArray = [String]()
    var jokeCategoryArray = [String]()
    @IBOutlet weak var jokeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
    }
    
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
             //get RANDOM Joke
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")!
                let categoryResult = jsonObj?.value(forKeyPath: "value.categories") as! [String]
                self.jokesArray.append(jsonResult as! String)
                
                
             
                
                
                
                if categoryResult != []{
                    var auxCategory = String(describing: categoryResult)
                    auxCategory = auxCategory.replacingOccurrences(of: "[", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "]", with: "")
                    auxCategory = auxCategory.replacingOccurrences(of: "\"", with: "")
                    
                   // print(auxCategory)
                    
                    self.jokeCategoryArray.append(String(describing: auxCategory))
                }
                
                //print(categoryResult)
                
                
                
                
                
                OperationQueue.main.addOperation({
                    self.showJokes()
                  //  self.showJokeCategory()
                })
                
            }
            
        }).resume()
    }
    
    func showJokes(){
        for joke in jokesArray{
            //print(joke)
        }
        jokeLabel.text = jokesArray.last
    }
    
//    func showJokeCategory(){
//        for category in jokeCategoryArray{
//            print(category)
//        }
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingsAction(_ sender: Any) {
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    @IBAction func allJokesAction(_ sender: Any) {
        let allJokesStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let allJokesVC = allJokesStoryboard.instantiateViewController(withIdentifier: "AllJokesTableViewController") as! AllJokesTableViewController
        allJokesVC.myJokes = jokesArray
        allJokesVC.jokeCategory = jokeCategoryArray
        self.navigationController?.pushViewController(allJokesVC, animated: true)
    }
    
    @IBAction func getRandomJoke(_ sender: UIButton) {
        for _ in 1...100{
             getJsonFromUrl()
        }
       
    }

    
    }
    
    

