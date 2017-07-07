//
//  ImagesTableViewController.swift
//  Jokes
//
//  Created by Irina Țari on 6/30/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import CoreData


protocol GetImageFromRowDelegate {
    func getImageInformation(info: UIImage)
}



class ImagesTableViewController: UIViewController {

    
    
    
    var delegate: GetImageFromRowDelegate? = nil
    
    @IBOutlet weak var imagesTableView: UITableView!
   
    var imgs = [Pictures]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         getData()

        imagesTableView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        imagesTableView.reloadData()
        
    }

    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let viewController = AddImageViewController()
        self.present(viewController, animated: true, completion: nil)

        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    
    // fetching from CoreData
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try imgs = context.fetch(Pictures.fetchRequest())

            
        } catch  {
            print("fetch failed")
        }
        
    }

  

}

// MARK: - UITableViewDataSource
extension ImagesTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imgs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! SavedImageTableViewCell
        
        let image = imgs[indexPath.row]
        
        
        cell.savedImageLabel.text = image.name
      
        // DOWNLOAD IMAGE FOR ROW
        let url = URL(string: image.url!)!
        
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
                cell.savedImageView.image = UIImage(data: data)
                
                
            }
            
        }

    
    
    
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! SavedImageTableViewCell
        
        
        

        // if cell image is not empty
        if (cell.savedImageView.image != nil) {
            
            
            // Saving image to file Manager
            let imageData = UIImageJPEGRepresentation(cell.savedImageView.image!, 1)
            do {
                let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cucubau.jpg")
                
                //delegation
                
                               
                
                if (delegate != nil){
                    print("Delegate worked")
                    let imageInfo = cell.savedImageView.image
                    delegate?.getImageInformation(info: imageInfo!)
                }else {
                    print("DELEGATE NIL")
                }
                
                //Save image to Root
                try imageData?.write(to: path, options:  .atomic)
                print("Saved To Root")
            } catch let error {
                print(error)
            }
            
            
            
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let image = imgs[indexPath.row]
            context.delete(image)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                try imgs = context.fetch(Pictures.fetchRequest())
            } catch {
                print("fetch failed on Delete")
            }
        }
        imagesTableView.reloadData()
        
    }
    
    // MARK: - Download functions
    
    // Get data from URL
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
//    // Download image
//    func downloadImage(url: URL)  {
//        
//        print("Download Started")
//        getDataFromUrl(url: url) { (data, response, error)  in
//            guard let data = data, error == nil else {
//                let alert = UIAlertController(title: "Unsafe URL", message: "The URL path you have chose does not start with HTTPS and it is not safe. Please choose an image with HTTPS URL prefix", preferredStyle: .alert)
//                
//                
//                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                alert.addAction(cancelAction)
//                
//                self.present(alert, animated: true, completion: nil)
//                
//                return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            
//                        DispatchQueue.main.async() { () -> Void in
//                       // image = UIImage(data: data)
//                            
//                            
//                        }
//            
//        }
//       
//    }
 
    
}

