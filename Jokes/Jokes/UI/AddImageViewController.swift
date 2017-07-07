//
//  AddImageViewController.swift
//  Jokes
//
//  Created by Irina Țari on 6/29/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import CoreData


class AddImageViewController: UIViewController {

    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var imageNameTextField: UITextField!
    
   
    
    

   var imgs = [Pictures]()
    
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
//    @IBAction func downloadWallpaper(_ sender: Any) {
//        
//        let downloadGroup = DispatchGroup()
//        
//        downloadGroup.enter()
//        if  let urlPath = URL(string: self.urlTextField.text!) {
//            
//            self.downloadImage(url: urlPath)
//            downloadGroup.leave()
//            
//            let alert = UIAlertController.init(title: "Succesfully downloaded!", message: "Press the Save button to add the wallpaper to your Saved Pictures, or cancel if you want to exit without saving", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(cancel)
//            self.present(alert, animated: true)
    
            
            
//            
//            
//            // Download unsuccesfull
//        } else {
//            let alertView = UIAlertController.init(title: "Error", message: "Add viable URL before saving", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertView.addAction(cancelAction)
//            self.present(alertView, animated: true)
//            
//        }
//        downloadGroup.wait()
//        downloadGroup.notify(queue: DispatchQueue.main) {
//            
//        }
//
//        
//    }
    
    
    
    @IBAction func saveImage(_ sender: Any) {
        
        
        
        // fetching text from name field and image from UIImageView, checking if empty
        
        let imageName = imageNameTextField.text
        //let imageView = urlImageView.image
        if imageName == "" {
            let alertView = UIAlertController.init(title: "Error", message: "Give your image a name before saving", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)
        } else if urlTextField.text == "" {
            let alertView = UIAlertController.init(title: "Error", message: "Please insert URL into text field", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)

        } else {
        
        
        // Saving in CoreData
        
        let reuquest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
            
       // let imageData: NSData = UIImagePNGRepresentation(urlImageView.image!)! as NSData
        let imageName = imageNameTextField.text
         let imageURL = urlTextField.text
        
        
           

    
        do {
            imgs = try managedContext.fetch(reuquest) as! [Pictures]
            
           let image = Pictures(context: managedContext)
                
                // if url is not saved already
                if (checkURL(pastedURL: imageURL!, pictures: imgs)) == false {
                        
                       // image.image = imageData
                        image.name = imageName
                        image.url = imageURL
                        imgs.append(image)
                        

                        let alertView = UIAlertController.init(title: "Wallpaper saved", message: "Press Cancel to continue", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in self.dismiss(animated: true, completion: nil)})
                        alertView.addAction(cancelAction)
                        present(alertView, animated: true)
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                                
                   
                            
                            //if url exists
                    } else {
                        let alertView = UIAlertController.init(title: "Wallpaper NOT saved", message: "Wallpaper already exists. Press Cancel to continue", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertView.addAction(cancelAction)
                        present(alertView, animated: true)
                        managedContext.delete(image)
                    }
            } catch {
                print("fetch failed")
            }
        
        
        }
        
        // clearing text fields
        imageNameTextField.text = ""
        urlTextField.text = ""
        //dismiss(animated: true, completion: nil)
     
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.isUserInteractionEnabled = true
        imageNameTextField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
        
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
    
    
    func checkURL(pastedURL: String, pictures: [Pictures]) -> Bool {
        var ok: Bool = false
       
        
        if pictures.count > 0 {
        for image in pictures {
            
            if String(image.url!)! == pastedURL {
                ok = true
                break
            } else {
                ok = false
            }
            
        }
        }
        return ok
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
