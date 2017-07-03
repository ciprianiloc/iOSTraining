//
//  SavedImagedViewController.swift
//  Jokes
//
//  Created by Irina Țari on 6/27/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import CoreData

class SavedImagedViewController: UIViewController {

    @IBOutlet weak var SavedImagesTableView: UITableView!
  
    @IBOutlet weak var savedNameLabel: UILabel!
    @IBOutlet weak var savedImageView: UIImageView!
    

    var imgs = [Pictures]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        SavedImagesTableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "TableCell")
        
        getData()
    }

    @IBAction func addImage(_ sender: Any) {
        
        let viewController = AddImageViewController()
        self.present(viewController, animated: true, completion: nil)
        

        
        
    }
    

    
   
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try imgs = context.fetch(Pictures.fetchRequest())
        } catch  {
            print("fetch failed")
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


// MARK: - UITableViewDataSource
extension SavedImagedViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! SavedImageTableViewCell
        
        let image = imgs[indexPath.row]
        
        cell.savedNameLabel.text = image.name
        
        //cell.savedNameLabel.text = String(describing: picture.name!)
        
        SavedImagesTableView.reloadData()
        
           // let image = imgs[indexPath.row]
            //image = images.init()
//            cell.textLabel?.text = image.value(forKey: "name") as! String
//            cell.imageView?.image = image.value(forKey: "image") as! UIImage
        
        
            
            return cell
    }
}

