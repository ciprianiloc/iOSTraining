//
//  ViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 20/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit





class HomeViewController: UIViewController{
    
    var settings:SettingsViewController?

    let URLApi = "http://api.icndb.com/jokes/random"
    var jokesArray = [String]()
    @IBOutlet weak var jokeLabel: UILabel!
    
    @IBOutlet var homeView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonFromUrl()
    
       
        
    }
    
    
//    func handleSettings() {
//        delegate?.changeFont
//    }
    
    
    
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
        for joke in jokesArray{
            print(joke)
        }
        jokeLabel.text = jokesArray.last
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingsAction(_ sender: Any) {
        let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsVC.delegate = self
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    @IBAction func allJokesAction(_ sender: Any) {
        let allJokesStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let allJokesVC = allJokesStoryboard.instantiateViewController(withIdentifier: "AllJokesTableViewController") as! AllJokesTableViewController
        allJokesVC.myJokes = jokesArray
        self.navigationController?.pushViewController(allJokesVC, animated: true)
    }
    
    @IBAction func getRandomJoke(_ sender: UIButton) {
        getJsonFromUrl()
    }

    
    }


extension HomeViewController: SettingsDelegate {
    
    
    
    
    func changeFont() {
        let defaults = UserDefaults.standard
        let font = defaults.string(forKey: "font")
        let fontSize = defaults.integer(forKey: "fontSize")
        
        if (font != nil) {
            jokeLabel.font = UIFont(name: font!, size: CGFloat(fontSize))
            
        } else {
            jokeLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 17)
        }
        
        
        let fontColorHex = defaults.string(forKey: "fontColor")
        if fontColorHex != nil {
            jokeLabel.textColor = UIColor(hex: (fontColorHex)!)
        } else {
            jokeLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }

    }
    func changeBackground() {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let fileManager = FileManager.default
        let imagePAth = (documentsDirectory as NSString).appendingPathComponent("cucubau.jpg")
        
        if fileManager.fileExists(atPath: imagePAth){
           
            self.backgroundImageView.image = UIImage(contentsOfFile: imagePAth)!
            self.backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.backgroundImageView.contentMode = UIViewContentMode.center
            
            
        } else {
            print("Using default image")
            self.backgroundImageView.image = UIImage(named: "images.jpg")
            self.backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
    }
        
}

    

