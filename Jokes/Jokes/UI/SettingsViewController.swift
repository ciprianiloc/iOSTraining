//
//  SettingsViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

 @IBOutlet weak var fontPickerView: UIPickerView!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var fontSizeSlider: UISlider!
    
    @IBAction func cancelButton(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
       
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func saveButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        //let defaults = UserDefaults.standard
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
