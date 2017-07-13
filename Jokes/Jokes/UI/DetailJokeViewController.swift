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
import AVFoundation
import Social

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
    var selectedRating : Double? = 1
    var jokes: [Joke] = []
    var jokeID : NSManagedObjectID = NSManagedObjectID()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = selectedJoke
        jokeCategoryLabel.text = selectedCategory
        
        
        ratingView.didTouchCosmos = { rating in
            self.selectedRating = rating
        }
        
        
        
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(DetailJokeViewController.ratingLevelChanged), userInfo: nil, repeats: true)
       // RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveJokeModification))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func ratingLevelChanged(){
        getRating(rating: Int(ratingView.rating))
    }
    
    func getAJoke(withObjectID id : NSManagedObjectID){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        
        
        do {
            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
            
            for joke in jokes{
                if id == joke.objectID{
                    self.jokeID = id
                }
            }
            

        } catch  {
            print("fetching failed")
        }
        
        
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
        //fetch the joke with id jokeID and change its rating to selectedRating
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
            
            for joke in jokes{
                if self.jokeID == joke.objectID{
                    joke.jokeRating = self.selectedRating!
                }
            }
        } catch  {
            print("fetching failed")
        }
        
         (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
       
        navigationController?.popViewController(animated: true) //get back to tableViewController
        
    }

    func changeRating(rating : Double) -> Double{
        return rating
    }
  
    @IBAction func textToSpeech(_ sender: UIButton) {
        let synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: detailLabel.text!)
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.setInitialText(self.detailLabel.text)
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    

}






