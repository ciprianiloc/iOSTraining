//
//  AllJokesTableViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/21/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class AllJokesTableViewController: UITableViewController {

    
    @IBOutlet var allJokesTableView: UITableView!
    
    var myJokes : [String] = [String]()
    var myTitle : String = ""
    
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        myTitle = "Nerdy"
        
        
        return myTitle
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame : CGRect = tableView.frame
        
        let title : UILabel = UILabel(frame:CGRect(x: 20, y: 0, width: 50, height: 20))
        title.backgroundColor = UIColor.red
        title.text = "Nerdy"
        title.textColor = UIColor.white
        
        
        let ratingButton : UIButton = UIButton(frame: CGRect(x: 200, y: 0, width: 60, height: 20))
            ratingButton.setTitle("Rating",for:.normal)
            ratingButton.backgroundColor = UIColor.red
            ratingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            ratingButton.addTarget(self, action: #selector(ratingButtonPressed), for: .touchUpInside)
        
        let dateButton : UIButton = UIButton(frame: CGRect(x: 290, y: 0, width: 100, height: 20))
            dateButton.setTitle("Date added", for: .normal)
            dateButton.backgroundColor = UIColor.red
            dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            dateButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
        
        let ratingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        ratingView.backgroundColor = UIColor.white
        ratingView.addSubview(ratingButton)
        ratingView.addSubview(dateButton)
        ratingView.addSubview(title)
        
        
        return ratingView
    }
    
    
    func ratingButtonPressed(sender : UIButton){
        print("rating button pressed")
    }
    
    func dateButtonPressed(sender : UIButton){
        print("date sorting button pressed")
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        
     
        let joke = myJokes[indexPath.row]
      
  
        cell.jokeLabel.text = joke
        
        let random = Int(arc4random_uniform(6))
        
        if random > 0{
            cell.ratingStarsView.rating = Double(random)
        }else{
            cell.ratingStarsView.rating = 1
        }
   
        
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
