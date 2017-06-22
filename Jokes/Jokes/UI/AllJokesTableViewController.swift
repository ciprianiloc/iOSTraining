//
//  AllJokesTableViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/21/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class AllJokesTableViewController: UITableViewController {

    
    
    var myJokes : [String] = [String]()
    
   // @IBOutlet weak var jokeNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJokeButton(_:)))
        
        
        
        for i in 1...25{
            myJokes.append("Joke number \(i)")
        }
 
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myJokes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        
        let joke = myJokes[indexPath.row]
      
  
        cell.jokeLabel.text = joke
        cell.jokeImageView.image = imageForRating(rating: Int(arc4random_uniform(6)))
        
   
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailJoke") as? DetailJokeViewController
        detailView?.selectedJoke = myJokes[indexPath.row]
       
    
        navigationController?.pushViewController(detailView!, animated: true)
    }
    
    
    @IBAction func addNewJokeButton(_ sender: Any) {
        let addJokeStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let addJokeVC = addJokeStoryboard.instantiateViewController(withIdentifier: "AddNewJokeViewController")
        self.present(addJokeVC, animated: true, completion: nil)
    }
    
    func imageForRating(rating : Int) -> UIImage{
        switch rating {
        case 1:
            return UIImage(named: "1StarSmall")!
        case 2:
            return UIImage(named: "2StarsSmall")!
        case 3:
            return UIImage(named: "3StarsSmall")!
        case 4:
            return UIImage(named: "4StarsSmall")!
        case 5:
            return UIImage(named: "5StarsSmall")!
        default:
            return UIImage(named: "1StarSmall")!
    }
}

}
