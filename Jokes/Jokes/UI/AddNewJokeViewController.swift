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
    
    var pickerData : [JokeCategory] = []
    var jokes : [Joke] = []
    //need to add categories to CoreData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAndAddMissingCategories()
    }
    
    func getAndAddMissingCategories(){
        let requestJoke = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let requestCategory = NSFetchRequest<NSFetchRequestResult>(entityName: "JokeCategory")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            jokes = try managedContext.fetch(requestJoke) as! [Joke]
            pickerData = try managedContext.fetch(requestCategory) as! [JokeCategory]
            
            for category in pickerData{
              //  print(category.categoryName)
               //
                managedContext.delete(category)
                
                
                if  !self.pickerData.contains(where: {$0.categoryName == "Unknown"}){
                    print(category)
                }
                
            
                
            }
                
                
            }catch  {
            print("fetch for category failed")
        }
    
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
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
        
        return pickerData[row].categoryName
    }
    
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    @IBAction func addNewCategory(_ sender: UIButton) {
        
        //save the new category to CoreData
        
//                if !pickerData.contains(newCategoryTextField.text!){
//                    pickerData.append(newCategoryTextField.text!)
//                }
    }

    

}
