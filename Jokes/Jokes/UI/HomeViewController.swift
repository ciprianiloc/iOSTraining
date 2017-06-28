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
    var jokeCategoryArray = [String]()
    @IBOutlet weak var jokeLabel: UILabel!
    var alljokesCategory : AllJokesTableViewController = AllJokesTableViewController()
    var selectedJokeLabel : String?
    var jokes : [Joke] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // mainRequest.getJsonFromUrl()
    
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFirstJoke()
    }
   
   
    
    func getFirstJoke(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try jokes = context.fetch(Joke.fetchRequest())
        }catch {
            print("error while fetching data from CoreData")
        }
        
        self.jokeLabel.text = jokes.last?.jokeDescription
       // self.jokeLabel.text = selectedJokeLabel

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
        self.navigationController?.pushViewController(allJokesVC, animated: true)
    }
    
    @IBAction func getRandomJoke(_ sender: UIButton) { //tap button to add random joke to CoreData
//        let requestJoke = RequestManager()
//        requestJoke.getJsonFromUrl()
        mainRequest.getJsonFromUrl()
        getFirstJoke()
    }

    
    }
 var mainHomeVC = HomeViewController()
    

