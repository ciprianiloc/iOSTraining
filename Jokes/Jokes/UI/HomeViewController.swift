//
//  ViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 20/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit







class HomeViewController: UIViewController {
    
    var settings:SettingsViewController?

    let URLApi = "http://api.icndb.com/jokes/random"
    var jokesArray = [Joke]()
    var jokeCategoryArray = [String]()
    @IBOutlet weak var jokeLabel: UILabel!


    var alljokesCategory : AllJokesTableViewController = AllJokesTableViewController()
    var selectedJokeLabel : String?
    var jokes : [Joke] = []
    
    
    @IBOutlet var homeView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        changeFont()
        changeBackground()
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
        let settingsVC = settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsVC.delegate = self
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




extension HomeViewController: SettingsDelegate {
    
    func changeFont() {
        let defaults = UserDefaults.standard
        let font = defaults.string(forKey: "font")
        let fontSize = defaults.integer(forKey: "fontSize")
        
        
        
        if (font != nil) {
            jokeLabel.font = UIFont(name: font!, size: CGFloat(fontSize))
            
        } else {
            
            jokeLabel.font.verifyDefaults(label: jokeLabel)
        }
        
        
        let fontColorHex = defaults.string(forKey: "fontColor")
        if fontColorHex != nil {
            jokeLabel.textColor = UIColor(hex: (fontColorHex)!)
        } else {
            jokeLabel.font.verifyDefaults(label: jokeLabel)
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
            backgroundImageView.defaultBackground(imageView: backgroundImageView)
        }
        
    }
        
}

extension UIFont {
    
    
        func verifyDefaults(label: UILabel)  {
            let defaults = UserDefaults.standard
//            let font = defaults.string(forKey: "font")
//            let fontSize = defaults.string(forKey: "fontSize")
            //let fontColor = defaults.string(forKey: "fontColor")
            
//            if font == nil && fontSize == nil{
            
                label.font = UIFont(name: "TimesNewRomanPSMT", size: 17)
                
//            } else if font == nil && fontSize != nil {
//                
//                label.font = UIFont(name: "TimesNewRomanPSMT", size: CGFloat(Int(fontSize!)!))
//                
//            } else if font != nil && fontSize == nil {
//                label.font = UIFont(name: font!, size: CGFloat(Int(fontSize!)!))
//               
//            }
//            
//             if fontColor == nil {
            
                label.textColor = UIColor.black
                
//              
//            }
//        }
    }
}

extension UIImageView {
    
    func defaultBackground(imageView: UIImageView) {
        imageView.image = UIImage(named: "images.jpg")
        imageView.contentMode = .scaleAspectFit
        imageView.contentMode = UIViewContentMode.center
    }

    
}

