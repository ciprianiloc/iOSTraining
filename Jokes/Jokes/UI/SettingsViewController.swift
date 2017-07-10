//
//  SettingsViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func changeFont()
    func changeBackground()
    
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Delegate
    var delegate:SettingsDelegate?
    
    
    // UIImagePickerController
    let imagePicker = UIImagePickerController()
    
    
    // declaring font families variables and arrays
    var fontFamilies = UIFont.familyNames
    var fontNames = [String]()
    var fontSizes = [String]()
    
    
    //IBOutlets
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var fontLabel: UILabel!
    
    @IBOutlet weak var fontSizeLabel: UILabel!
  
    @IBOutlet weak var fontSlider: UISlider!
    
    @IBOutlet weak var fontColor: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    

  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Image picker delegate
        
        imagePicker.delegate = self
        
        
        // Get directory path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        
        // Get image from directory
        
        let fileManager = FileManager.default
        let imagePAth = (documentsDirectory as NSString).appendingPathComponent("cucubau.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.backgroundImage.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("Using default image")
            backgroundImage.image = #imageLiteral(resourceName: "default.jpg")
            
        }
        
                
        // take all fonts from fontFamilies and append to fontNames array
        for familyName in fontFamilies {
            
            fontNames.append(familyName)
        }
        
        
        // saving font settings using NSUserDefaults

        
        let defaults = UserDefaults.standard
        let font = defaults.string(forKey: "font")
    
        
        if (font != nil) {
        fontLabel.font = UIFont(name: font!, size: 17)
        
        }
        
        // saving in NSUserDefaults the position of the selected row from UIPickerView
        let selectedRow = defaults.integer(forKey: "selectedRow")
        pickerView.selectRow(selectedRow, inComponent: 0, animated: true)
        
        //slider - fontSizeLabel
        let fontSize = defaults.integer(forKey: "fontSize")
        
        if fontSlider.value == 0 {
            self.fontSlider.setValue(17, animated: true)
            fontSizeLabel.font = UIFont(name: self.fontNames[0], size: CGFloat(fontSize))
            fontSlider.setValue(Float(fontSize), animated: true)
            fontSlider.minimumValue = 15
        } else {
        
        fontSizeLabel.font = UIFont(name: self.fontNames[0], size: CGFloat(fontSize))
        fontSlider.setValue(Float(fontSize), animated: true)
        self.fontSizeLabel.text = "Font size: " + "\(Int(fontSlider.value))"
        }
        
        
        // font color
        let fontColorHex = defaults.string(forKey: "fontColor")
        if fontColorHex != nil {
        fontColor.backgroundColor = UIColor(hex: (fontColorHex)!)
        }
      
        
        
        
    }
    
    // MARK: - Buttons

    // changeFontColor button
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
    
    // changeFontSize slider action
    @IBAction func changeFontSize(_ sender: AnyObject) {

        let senderValue = CGFloat(fontSlider.value)
        self.fontSizeLabel.text = "Font size: " + "\(Int(senderValue))"
        fontSizeLabel?.font = UIFont(name: (fontSizeLabel?.font.fontName)!, size:senderValue)
    }
    
    // change background image button
    @IBAction func changeBackgroungImage(_ sender: Any) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
         let alert = UIAlertController(title: "Get Photos From:", message: nil, preferredStyle: .actionSheet)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // Photo library button
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {
            _ in
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(libraryAction)
        
        // Camera button
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
             _ in
                
            
            
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                
                let alertController = UIAlertController.init(title: nil, message: "Your device doesn't have a camera.", preferredStyle: .alert)
                
                let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else{
                //other action
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.present(self.imagePicker, animated: true, completion: nil)
               

            }
                
            
            }
         alert.addAction(cameraAction)
        
        
        
        
        // Internet button
        let internetAction = UIAlertAction(title: "Saved images", style: .default) {
            (action) -> Void
            in
           
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedImagesStoryboard") as? ImagesTableViewController
            viewController?.delegate = self
            self.present(viewController!, animated: true, completion: nil)
            

        }
        alert.addAction(internetAction)
        
        
        present(alert, animated: true, completion: nil)

       
        }
    

    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.image = pickedImage
            
            
    
        dismiss(animated: true, completion: nil)

    }
    }
    
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
   
    
   
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

    // change color to label function
    func setLabelColor (_ color: UIColor) {
       
        self.fontColor.backgroundColor = color
    }

    // MARK: - pickerView functions
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
        
        fontLabel?.font = UIFont(name: fontNames[row], size: 16)
        pickerView.selectRow(row, inComponent: 0, animated: true)
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
  
   
    
    
    // MARK: - View Controller Save & Cancel button
    @IBAction func cancelButton(_ sender: Any) {
       
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func saveButton(_ sender: Any) {
        

        
        // File Manager
        
        
        
        
        let imageData = UIImageJPEGRepresentation(backgroundImage.image!, 1)
        do {
            let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cucubau.jpg")
            //Save image to Root
            try imageData?.write(to: path, options:  .atomic)
            print("Saved To Root")
        } catch let error {
            print(error)
        }
        
        
        
        // User Defaults
        

        
        let defaults = UserDefaults.standard
        defaults.set(fontLabel.font.fontName, forKey: "font")

        defaults.set(fontSizeLabel.font.pointSize, forKey: "fontSize")
        
        let hexFontColor = fontColor.backgroundColor?.toHexString
        defaults.set(hexFontColor, forKey: "fontColor")
        
        
        let row = pickerView.selectedRow(inComponent: 0)
        defaults.set(row, forKey: "selectedRow")
        

    
        

        delegate?.changeFont()
        delegate?.changeBackground()
        
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    // settings ImagesTableViewController as delegate for changing background Image from Saved Images
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            
            let secondVC: ImagesTableViewController = segue.destination as! ImagesTableViewController
            secondVC.delegate = self
           
        }
        
    }
 

}


// MARK: - extension for row image delegate

extension SettingsViewController: GetImageFromRowDelegate {
    
    // image from row delegate function
    
    func getImageInformation(info: UIImage) {
        backgroundImage.image = info
    }
    

    
    
}

// MARK: - UIColor functions

// Function converting color to hex

extension UIColor {
    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}


// Function converting hex to color

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}



