//
//  SettingsViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var fontLabel: UILabel!
    
    @IBOutlet weak var fontSizeLabel: UILabel!
  
    @IBOutlet weak var fontSlider: UISlider!
    
    @IBOutlet weak var fontColor: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBAction func changeFontColor(_ sender: Any) {
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    
    @IBAction func changeFontSize(_ sender: AnyObject) {

        let senderValue = CGFloat(fontSlider.value)
        self.fontSizeLabel.text = "Font size: " + "\(Int(senderValue))"
        fontSizeLabel?.font = UIFont(name: (fontSizeLabel?.font.fontName)!, size:senderValue)
    }
    
    @IBAction func changeBackgroungImage(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    

    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.image = pickedImage
        }
        
    
        dismiss(animated: true, completion: nil)

    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
   var fontFamilies = UIFont.familyNames
    var fontNames = [String]()
    var fontSizes = [String]()
    
   
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

    
    func setLabelColor (_ color: UIColor) {
       // fontColor.setTitleColor(color, for:UIControlState())
        self.fontColor.backgroundColor = color
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return fontNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //fontLabel.text = fontNames[row]
        fontLabel?.font = UIFont(name: fontNames[row], size: 16)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        if(pickerLabel == nil) {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont(name: fontNames[row], size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        pickerLabel?.text = fontNames[row]
        
        return pickerLabel!
    }
  
   
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
       
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func saveButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
//        let defaults = UserDefaults.standard
//        defaults.set(fontPickerView, forKey: "Font")
//        defaults.set(fontSizeSlider, forKey: "FontSize")
//        defaults.set(colorView, forKey: "FontColor")
//        defaults.set(imageView, forKey: "BackgroundImage")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate

        // Do any additional setup after loading the view.
        for familyName in fontFamilies {
            //let names = UIFont.fontNames(forFamilyName: familyName )
           
            fontNames.append(familyName)
        }
        
        
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
