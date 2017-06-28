//
//  SettingsViewController.swift
//  Jokes
//
//  Created by Ciprian Iloc on 21/06/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
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
        
        
        // Get image
        
        let fileManager = FileManager.default
        let imagePAth = (documentsDirectory as NSString).appendingPathComponent("cucubau.jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.backgroundImage.image = UIImage(contentsOfFile: imagePAth)
        }else{
            print("Using default image")
            backgroundImage.image = #imageLiteral(resourceName: "images.jpeg")
        }
        
        
        
        // all fonts
        for familyName in fontFamilies {
            
            fontNames.append(familyName)
        }
        
        
        // font settings
        //let defaults = UserDefaults.standard
        
//        if let loadedStrings = NSKeyedUnarchiver.unarchiveObject(withFile: fullPathURL.absoluteString) as? [String] {
//            savedArray = loadedStrings
//        }
        
      
        let randomFilename = UUID().uuidString
        
        let fullPath = (documentsDirectory as NSString).appendingPathComponent(randomFilename)
        let fullPathURL = URL(string: fullPath)
      
    
        if  let data = NSKeyedUnarchiver.unarchiveObject(withFile: (fullPathURL?.absoluteString)!) {
            let savedFontString = data
            fontLabel.font = savedFontString as! UIFont
        }
        
        
        
        
    }
    
    
    
    
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
        
        // Get data from URL
        func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                completion(data, response, error)
                }.resume()
        }
        
        // Download image
        func downloadImage(url: URL) {
            print("Download Started")
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else {
                    let alert = UIAlertController(title: "Unsafe URL", message: "The URL path you have chose does not start with HTTPS and it is not safe. Please choose an image with HTTPS URL prefix", preferredStyle: .alert)
                    
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    self.backgroundImage.image = UIImage(data: data)
                }
            }
        }
        
        
        
        // Internet button
        let internetAction = UIAlertAction(title: "Saved images", style: .default) {
            (action) -> Void
            in
           
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SavedImagesStoryboard")
            self.present(viewController!, animated: true, completion: nil)
            
            let urlPath = URL(string: "https://image.freepik.com/free-vector/orange-geometric-background-with-halftone-dots_1035-7243.jpg")
          
           

            downloadImage(url: urlPath!)
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
    
    
    
    
    
   var fontFamilies = UIFont.familyNames
    var fontNames = [String]()
    var fontSizes = [String]()
    
   
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

    
    func setLabelColor (_ color: UIColor) {
       
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
        

        
        // File Manager
        let fileManager = FileManager.default

        let imageData = UIImageJPEGRepresentation(backgroundImage.image!, 0.5)
        fileManager.createFile(atPath: "/documents/" as String, contents: imageData, attributes: nil)
        
        let path = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("cucubau.jpg")
        do {
            //Save image to Root
            try imageData?.write(to: path, options:  .atomic)
            print("Saved To Root")
        } catch let error {
            print(error)
        }
        
        // User Defaults
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let randomFilename = UUID().uuidString
        let data = NSKeyedArchiver.archivedData(withRootObject: fontLabel.font)
        let fullPath = (documentsDirectory as NSString).appendingPathComponent(randomFilename)
        let fullPathURL = URL(string: fullPath)
        
        do {
            try data.write(to: fullPathURL!)
        } catch {
            print("Could not write file (font)")
        }
        
        
        self.navigationController?.popViewController(animated: true)
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






