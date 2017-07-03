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
    
    
//    struct images {
//        var name: NSManagedObject
//        var image: NSManagedObject
//        
//        init(name: NSManagedObject, image: NSManagedObject) {
//            self.name = name
//            self.image = image
//        }
//    }
//    var imgs = [images]()
    
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveImage(_ sender: Any) {
        
        if  let urlPath = URL(string: urlTextField.text!) {
        
        downloadImage(url: urlPath)
            
            let alert = UIAlertController.init(title: "Succesfully downloaded!", message: "Press the Cancel button on the top left of the screen to view your Saved Pictures", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        } else {
            let alertView = UIAlertController.init(title: "Error", message: "Add viable URL before saving", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)
            
        }
        
        
        
        // fetching text from name field, checking if empty
        
        let imageName = imageNameTextField.text
        if imageName == "" {
            let alertView = UIAlertController.init(title: "Error", message: "Give your image a name before saving", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertView.addAction(cancelAction)
            present(alertView, animated: true)
        }
        
        
        
        // Saving in CoreData
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let image = Pictures(context: context)
        image.name = imageNameTextField.text
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        

        
        // clearing text fields
        imageNameTextField.text = ""
        urlTextField.text = ""

        

        
        
        
       // dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.isUserInteractionEnabled = true
        imageNameTextField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
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

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
