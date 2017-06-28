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
    var jokesArray = [Joke]()
    //var jokesDictionary = [String:String]()
    var jokeCategoryArray = [String]()
    @IBOutlet weak var jokeLabel: UILabel!
    var alljokesCategory : AllJokesTableViewController = AllJokesTableViewController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  
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
        allJokesVC.jokes = jokesArray
//        allJokesVC.jokeCategory = jokeCategoryArray
//        allJokesVC.selectedCategory = String(describing: alljokesCategory)
        
      //  let request = RequestManager()
        
       // allJokesVC.jokes = request.jokesArray
        self.navigationController?.pushViewController(allJokesVC, animated: true)
    }
    
    @IBAction func getRandomJoke(_ sender: UIButton) { //tap button to add random joke to CoreData
        let requestJoke = RequestManager()
        requestJoke.getJsonFromUrl()
    }

    
    }
    
    

