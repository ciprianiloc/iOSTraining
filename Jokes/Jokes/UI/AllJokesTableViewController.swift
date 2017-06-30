//
//  AllJokesTableViewController.swift
//  Jokes
//
//  Created by Cristian Banarescu on 6/21/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import CoreData


class AllJokesTableViewController: UITableViewController {

    
    @IBOutlet var allJokesTableView: UITableView!
    
    var myJokes :[String] = [String]()
    var myTitle : String = ""
    var jokeCategory : [String] = [String]()
    var selectedCategory : String = ""
    var jokes : [Joke] = []
    var ratingFromDetailController : Int?
    var results : [Joke] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJokeButton(_:)))
        allJokesTableView.delegate = self
        allJokesTableView.dataSource = self
        //getAJoke()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        allJokesTableView.reloadData()
        //getAJoke()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 	1 //jokeCategory.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return jokes.count//myJokes.count
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.jokeCategory[section]
//    }
    
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
            ratingButton.setTitleColor(UIColor.black, for: .normal)
            ratingButton.backgroundColor = UIColor(red: 79/255, green: 233/255, blue: 83/255, alpha: 0.5)
            ratingButton.layer.cornerRadius = 5
            ratingButton.layer.borderWidth = 2
            ratingButton.layer.borderColor = UIColor.black.cgColor
            ratingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
            ratingButton.addTarget(self, action: #selector(ratingButtonPressed), for: .touchUpInside)
        
        let dateButton : UIButton = UIButton(frame: CGRect(x: 310, y: 0, width: 100, height: 20))
            dateButton.setTitle("Date added", for: .normal)
            dateButton.setTitleColor(UIColor.black, for: .normal)
            dateButton.backgroundColor = UIColor(red: 79/255, green: 233/255, blue: 83/255, alpha: 0.5)
            dateButton.layer.cornerRadius = 5
            dateButton.layer.borderWidth = 2
            dateButton.layer.borderColor = UIColor.black.cgColor
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
        let joke = jokes[indexPath.row]
        
        cell.jokeLabel.text = String(describing: joke.jokeDescription!)
        cell.ratingStarsView.rating = 3
        

        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailJoke") as? DetailJokeViewController
        detailView?.selectedJoke = String(describing: jokes[indexPath.row].jokeDescription!)
        detailView?.selectedCategory = String(describing: jokes[indexPath.row].jokeCategory!)
       
        
        
        //make a fetch request with an ID parameter ( from CoreData) to access a specific joke and change its rating 
        //after changing rating, reload the tableView

        
        
        
        navigationController?.pushViewController(detailView!, animated: true)
    }
    
    
   
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if editingStyle == .delete{
            let joke = jokes[indexPath.row]
            context.delete(joke)
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            
            do {
                try jokes = context.fetch(Joke.fetchRequest())
            } catch  {
                print("fecth failed on DELETE")
            }
        }
        allJokesTableView.reloadData()
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
    
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        do{
            try jokes = context.fetch(Joke.fetchRequest())
        }catch {
            print("error while fetching data from CoreData")
        }
    }
    
   
    
}


