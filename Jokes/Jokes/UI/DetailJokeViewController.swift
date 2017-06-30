//
//  DetailJokeViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/22/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DetailJokeViewController: UIViewController {

    
    @IBOutlet var detailJokeView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var funnyLevelLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var jokeCategoryLabel: UILabel!
    
    
    
    var selectedJoke : String?
    var selectedImage : UIImage?
    var selectedCategory : String?
    var selectedRating : Double?
    var jokes: [Joke] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = selectedJoke
        jokeCategoryLabel.text = selectedCategory
        
        ratingView.didTouchCosmos = { rating in
            self.selectedRating = rating
            //print(rating)
                   }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DetailJokeViewController.ratingLevelChanged), userInfo: nil, repeats: true)
       // RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveJokeModification))
        
        
        getAJoke()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func ratingLevelChanged(){
        getRating(rating: Int(ratingView.rating))
    }
    
    
    func getRating(rating: Int){
        switch rating {
        case 1:
            funnyLevelLabel.text = "1 level Funny"
        case 2:
            funnyLevelLabel.text = "2 levels Funny"
        case 3:
            funnyLevelLabel.text = "3 levels Funny"
        case 4:
            funnyLevelLabel.text = "4 levels Funny"
        case 5:
            funnyLevelLabel.text = "5 levels Funny"
        default:
            funnyLevelLabel.text = "1 level Funny"
        }
    }
    
    func saveJokeModification(){
        //get selected rating 
        if let changedRating = self.selectedRating{
            print(changedRating)
        }
        
        
        
        navigationController?.popViewController(animated: true) //get back to tableViewController
    }

    
    func getAJoke(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
            
            for joke in jokes{
                if let jokeDescription = joke.jokeDescription{
                  //  if joke.jokeCategory == "nerdy"{
                        //print(jokeDescription)
                       
                            print(joke.objectID)
                        
                   // }
                    
                }
            }
        } catch  {
            print("fetching failed")
        }
        
    }

}






