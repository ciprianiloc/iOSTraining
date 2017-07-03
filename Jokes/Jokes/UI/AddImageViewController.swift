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
    
    @IBOutlet weak var urlImageView: UIImageView!
    
    

   var imgs = [Pictures]()
    
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func downloadWallpaper(_ sender: Any) {
        
        let downloadGroup = DispatchGroup()
        
        downloadGroup.enter()
        if  let urlPath = URL(string: self.urlTextField.text!) {
            
            self.downloadImage(url: urlPath)
            downloadGroup.leave()
            
            let alert = UIAlertController.init(title: "Succesfully downloaded!", message: "Press the Save button to add the wallpaper to your Saved Pictures, or cancel if you want to exit without saving", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true)
            
            
            
            
            
            // Download unsuccesfull
        } else {
            let alertView = UIAlertController.init(title: "Error", message: "Add viable URL before saving", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true)
            
        }
        downloadGroup.wait()
        downloadGroup.notify(queue: DispatchQueue.main) {
            
        }

        
    }
    
    
    
    @IBAction func saveImage(_ sender: Any) {
        
        
        
        // fetching text from name field and image from UIImageView, checking if empty
        
        let imageName = imageNameTextField.text
        let imageView = urlImageView.image
        if imageName == "" {
            let alertView = UIAlertController.init(title: "Error", message: "Give your image a name before saving", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)
        } else if imageView == nil {
            let alertView = UIAlertController.init(title: "Error", message: "You can not save if image was not downloaded succesfully", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)

        } else {
        
        
        // Saving in CoreData
        
        let reuquest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pictures")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let imageData: NSData = UIImagePNGRepresentation(urlImageView.image!)! as NSData
        
        let image = Pictures(context: managedContext)
        image.image = imageData
        image.name = imageNameTextField.text
        
        
        
        do {
            imgs = try managedContext.fetch(reuquest) as! [Pictures]
            
           
                // if image is not saved already
                if checkImage(picture: image, pictures: imgs) {
                    
                     imgs.append(image)
                    
                    
                    let alertView = UIAlertController.init(title: "Wallpaper saved", message: "Press Cancel to continue", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertView.addAction(cancelAction)
                    present(alertView, animated: true)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    //if not
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
                self.urlImageView.image = UIImage(data: data)
            }
        }
    }

    
    func checkImage(picture: Pictures, pictures: [Pictures]) -> Bool {
        var ok: Bool = true
        for image in pictures {
            if image.name == picture.name || image.image == picture.image {
                ok = false
                continue
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
