//
//  AddNewJokeViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/21/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AddNewJokeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  

    @IBOutlet weak var jokePickerView: UIPickerView!
    @IBOutlet weak var jokeDescription: UITextView!
    @IBOutlet weak var newCategoryTextField: UITextField!
    
    var pickerData : [String] = []
    var jokes : [Joke] = []
    var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAndAddMissingCategories()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - picker methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedRow = row
        return pickerData[row]
    }
    
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //MARK: - helper methods
    
    
    func getAndAddMissingCategories(){
        let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            jokes = try managedContext.fetch(requestJoke) as! [Joke]
            
            for joke in jokes{
                if !pickerData.contains(joke.jokeCategory!){
                    pickerData.append(joke.jokeCategory!)
                }
            }
        }catch  {
            print("fetch for category failed")
        }
        
        do{
            try   managedContext.save()
        }catch {
            print("failed to save")
        }
    }
    
    //MARK: - buttons
    
    @IBAction func cancelAddJoke(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func saveJoke(_ sender: UIBarButtonItem) {
        //save the new category to CoreData
        let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            jokes = try managedContext.fetch(requestJoke) as! [Joke]
            //add a new category only if you add a new Joke
            
            if jokeDescription.text != ""{
                let joke = Joke(context: managedContext)
                joke.jokeDescription = jokeDescription.text
                
                if newCategoryTextField.text != ""{
                    joke.jokeCategory = newCategoryTextField.text
                }else{
                    joke.jokeCategory = pickerData[self.selectedRow]
                    
                }
                joke.jokeDateAdded = mainRequest.initializeCalendarForJokeDate().0.date(from: mainRequest.initializeCalendarForJokeDate().1)! as NSDate
                
                let randomJokeRating = Double(arc4random_uniform(6))
                
                if randomJokeRating > 0 {
                    joke.jokeRating = randomJokeRating
                }else{
                    joke.jokeRating = 1
                }
                
                print(joke.jokeDateAdded!)
                
            }
        }catch  {
            print("failed to request joke - add new category")
        }
    
        jokeDescription.text = ""
        newCategoryTextField.text = ""
        jokePickerView.reloadAllComponents()
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
}


