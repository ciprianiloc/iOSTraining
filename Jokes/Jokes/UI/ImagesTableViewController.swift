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



class ImagesTableViewController: UIViewController, UISearchBarDelegate {

    
    
    
    var delegate: GetImageFromRowDelegate? = nil // delegate type GetImageFromRowDelegate
    
    @IBOutlet weak var imagesTableView: UITableView! // IBOutlet for TableView
   
    @IBOutlet weak var imagesSearchBar: UISearchBar!
    
    var imgs = [Pictures]() // array type Pictures entity (CoreData)
    var filteredImgs = [Pictures]()
    
   var isSearching = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         getData()

        imagesTableView.reloadData()
        
        imagesSearchBar.delegate = self
        imagesSearchBar.returnKeyType = UIReturnKeyType.done
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        imagesTableView.reloadData()
        
    }

    // MARK: - Buttons IBActions
    
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

    
    // MARK: - SearchBar functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            imagesTableView.reloadData()
        } else {
            
            isSearching = true
            
            filteredImgs = imgs.filter({image in
                if image.name?.lowercased().range(of:searchText.lowercased()) != nil {
                    return true
                } else {
                    return false
                }
            })
            imagesTableView.reloadData()
            
            
        }
        
    }

   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - function fetching from CoreData
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try imgs = context.fetch(Pictures.fetchRequest())

            
        } catch  {
            print("fetch failed")
        }
        
    }

  

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ImagesTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredImgs.count
        } else {
        return imgs.count
        }
    }
    
    
    
    // editing cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! SavedImageTableViewCell
        
        var image = [Pictures]()
        
        if isSearching {
             image = filteredImgs
            cell.savedImageLabel.text = filteredImgs[indexPath.row].name
            return cell
                } else {
             image = imgs
             cell.savedImageLabel.text = imgs[indexPath.row].name
            
                // DOWNLOAD IMAGE FOR ROW
            let url = URL(string: image[indexPath.row].url!)!
            
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else {
                    print("Getting data failed")
                    return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                
                DispatchQueue.main.async() { () -> Void in
                    cell.savedImageView.image = UIImage(data: data)
                    
                }
                
            }
            return cell
        }

    }

    
    
    
    // didSelectRow action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // using CellForRow function to get rows
        let cell = tableView.cellForRow(at: indexPath) as! SavedImageTableViewCell
        

        // if cell image is not empty
        if (cell.savedImageView.image != nil) {
                
                //delegation
                if (delegate != nil){
                    print("Delegate worked")
                    let imageInfo = cell.savedImageView.image  // saving image into imageInfo immutable var
                    delegate?.getImageInformation(info: imageInfo!) // calling protocol function
                }else {
                    print("DELEGATE NIL")
                }
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    
    // Delete button for rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // if delete pressed
        if editingStyle == .delete {
            let image = imgs[indexPath.row] // select the row
            context.delete(image) //delete row
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext() // save context
            
            // try to fetch the new context
            do {
                try imgs = context.fetch(Pictures.fetchRequest())
            } catch {
                print("fetch failed on Delete")
            }
        }
        // reload data in table view
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
    
}


