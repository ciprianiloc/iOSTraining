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
    var jokeCategory : [String] = ["nerdy","very lame","funniest"]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJokeButton(_:)))
        
        
        
        for i in 1...125{
            myJokes.append("joke number \(i)")
           
        }
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 	jokeCategory.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.jokeCategory[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame : CGRect = tableView.frame
        
        let title : UILabel = UILabel(frame:CGRect(x: 20, y: 0, width: 100, height: 20))
        title.backgroundColor = UIColor.red
        title.text = self.jokeCategory[section]
        title.textColor = UIColor.white
        title.textAlignment = .center
        
        
        let sortBylabel : UILabel = UILabel(frame: CGRect(x: 160, y: 0, width: 70, height: 20))
        sortBylabel.backgroundColor = UIColor.red
        sortBylabel.text = "Sort By:"
        sortBylabel.textColor = UIColor.white
        
        
        let ratingButton : UIButton = UIButton(frame: CGRect(x: 240, y: 0, width: 60, height: 20))
            ratingButton.setTitle("Rating",for:.normal)
            ratingButton.backgroundColor = UIColor.red
            ratingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            ratingButton.addTarget(self, action: #selector(ratingButtonPressed), for: .touchUpInside)
        
        let dateButton : UIButton = UIButton(frame: CGRect(x: 310, y: 0, width: 100, height: 20))
            dateButton.setTitle("Date added", for: .normal)
            dateButton.backgroundColor = UIColor.red
            dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            dateButton.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
        
        let ratingView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        ratingView.backgroundColor = UIColor.white
        ratingView.addSubview(ratingButton)
        ratingView.addSubview(dateButton)
        ratingView.addSubview(title)
        ratingView.addSubview(sortBylabel)
        
        
        return ratingView
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
        detailView?.selectedCategory = jokeCategory[Int(arc4random_uniform(3))]
        navigationController?.pushViewController(detailView!, animated: true)
    }
    
    
    @IBAction func addNewJokeButton(_ sender: Any) {
        let addJokeStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let addJokeVC = addJokeStoryboard.instantiateViewController(withIdentifier: "AddNewJokeViewController")
        self.present(addJokeVC, animated: true, completion: nil)
    }
    
    
    func ratingButtonPressed(sender : UIButton){
        print("will sort things")
    }
    
    func dateButtonPressed(sender : UIButton){
        print("date sorting button pressed")
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
