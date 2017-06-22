//
//  AddNewJokeViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/21/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import Foundation

class AddNewJokeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
  

    @IBOutlet weak var jokePickerView: UIPickerView!
//    @IBOutlet weak var jokeCategoryLabel: UILabel!
    @IBOutlet weak var jokeDescription: UITextView!
    @IBOutlet weak var newCategoryTextField: UITextField!
    
    var pickerData : [String] = [String] ()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["category1","category2","category3"]
       
        
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
