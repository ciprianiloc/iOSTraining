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
    //need to add categories to CoreData
    
    override func viewDidLoad() {
        super.viewDidLoad()
      getAndAddMissingCategories()
        
        //pickerData = ["Unknown","Nerdy","Explicit"]
        
    }
    
    func getAndAddMissingCategories(){
        let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
      //  let requestCategory = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeCategory")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAddJoke(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAddJoke(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        
//        let categoryRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeCategory")
//        
//        do {
//            try pickerData = context.fetch(categoryRequest) as! [JokeCategory]
//        } catch  {
//            print("fetch for picker failed")
//        }
        
        return pickerData[row]
    }
    
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    @IBAction func addNewCategory(_ sender: UIButton) {
        
        //save the new category to CoreData
        
                if !pickerData.contains(newCategoryTextField.text!){
                    pickerData.append(newCategoryTextField.text!)
                }
        self.jokePickerView.reloadAllComponents()
    }

    

}
