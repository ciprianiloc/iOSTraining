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
    @IBOutlet weak var jokeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
    }
    
    func getJsonFromUrl(){
        let url = NSURL(string: URLApi)
        
        
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data,response,error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary{
                let jsonResult = jsonObj!.value(forKeyPath: "value.joke")!
                self.jokesArray.append(jsonResult as! String)
                
                OperationQueue.main.addOperation({
                    self.showJokes()
                })
                
            }
            
        }).resume()
    }
    
    func showJokes(){
        jokeLabel.text = jokesArray.last
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
        let allJokesVC = allJokesStoryboard.instantiateViewController(withIdentifier: "AllJokesTableViewController")
        self.navigationController?.pushViewController(allJokesVC, animated: true)
    }
    
    @IBAction func getRandomJoke(_ sender: UIButton) {
        getJsonFromUrl()
    }
    
    
    
    }

