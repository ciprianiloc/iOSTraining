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
    
    var pickerData : [String] = [String] ()
    var jokes : [Joke] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            jokes = try managedContext.fetch(request) as! [Joke]
            
            for joke in jokes{
                if !pickerData.contains(joke.jokeCategory!){
                    pickerData.append(joke.jokeCategory!)
                }else{
                    continue
                }
            }
            
            
        } catch  {
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
        return pickerData[row]
    }
    
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    @IBAction func addNewCategory(_ sender: UIButton) {
        let newCategory = newCategoryTextField.text
        if newCategory != ""{
            pickerData.append(newCategory!)
            jokePickerView.reloadAllComponents()
        }
    }

    

}
