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
      
        if image.image != nil {
        cell.savedImageView.image = UIImage(data: image.image! as Data)
            
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
    
    
    
 
    
}

