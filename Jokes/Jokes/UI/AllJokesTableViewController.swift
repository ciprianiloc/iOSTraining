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
    
    var categories : [String] = []
    var isSorted : Bool = false
    var sortedJokesByRating : [Joke] = [Joke]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJokeButton(_:)))
        allJokesTableView.delegate = self
        allJokesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        allJokesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {                  //WORKS !!! gives the correct number of sections based on joke categories
            for joke in jokes{
                if !categories.contains(joke.jokeCategory!){
                    categories.append(joke.jokeCategory!)
                }
            }
        return 1 //categories.count
        //return  1 to come back to normal things
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        //fetch jokes that have the specified category
        
        //WORKING
        
        return jokes.count//getNumberOfJokesForCategory(category: categories[section])
            //jokes.count  RETURN THIS TO GO BACK TO NORMAL
        //getNumberOfJokesForCategory(category: categories[section])        //getAJoke(withObjectCategory: jokes[section].jokeCategory!)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "JokeCell", for: indexPath) as! JokeCell
        let joke = jokes[indexPath.row]

       
            cell.jokeLabel.text = String(describing: joke.jokeDescription!)
            cell.ratingStarsView.rating = jokes[indexPath.row].jokeRating
        
        
        
        //WORKING
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailJoke") as? DetailJokeViewController
        detailView?.selectedJoke = String(describing: jokes[indexPath.row].jokeDescription!)
        detailView?.selectedCategory = String(describing: jokes[indexPath.row].jokeCategory!)
        detailView?.getAJoke(withObjectID: jokes[indexPath.row].objectID)
        
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
    
    
    
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self.categories[section]
        }
    
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let frame : CGRect = tableView.frame
    
            let title : UILabel = UILabel(frame:CGRect(x: 20, y: 0, width: 100, height: 20))
            title.backgroundColor = UIColor.red
            title.text = self.categories[section]
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
    
    
    func getNumberOfJokesForCategory(category : String) -> Int{  //count the jokes for a specific category
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var countJokesForCategory = 0
        
        do {
            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
            
            for joke in jokes{
                if category == joke.jokeCategory{
                    countJokesForCategory += 1
                }
            }
        } catch  {
            print("fetching failed")
        }
        return countJokesForCategory
    }
    
    func getJokeFromSection(section: Int) -> [Joke]{
        var result : [Joke] = [Joke]()
        var finalResult : [Joke] = [Joke]()
        
        let fecthRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            result = try context.fetch(fecthRequest) as! [Joke]
            
            for joke in result{
                if joke.jokeCategory == String(self.categories[section]){
                    finalResult.append(joke)
                }
            }
            
        } catch  {
            print("fetched for a category failed")
        }
        
        
        return finalResult  //all jokes from the section
    }

    
    
    @IBAction func addNewJokeButton(_ sender: Any) {
        let addJokeStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let addJokeVC = addJokeStoryboard.instantiateViewController(withIdentifier: "AddNewJokeViewController")
        self.present(addJokeVC, animated: true, completion: nil)
    }
    
    
    func ratingButtonPressed(sender : UIButton){
       // print("will sort things")

        DispatchQueue.main.async(execute: {
            // Update your UI here
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            var result : [Joke] = [Joke]()
            //var sortedResult : [Joke] = [Joke]()
            
            do {
                result = try context.fetch(fetchRequest) as! [Joke]
                result = result.sorted(by: {$0.jokeRating > $1.jokeRating})
                
                self.jokes = result

                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                self.allJokesTableView.reloadData()
                
            } catch  {
                print("fetch failed for sorting jokes by rating")
            }
        })
        
        
        
        
    }
    
    func dateButtonPressed(sender : UIButton){
       // print("date sorting button pressed")
        
        
        let fecthForDate = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var result : [Joke] = [Joke]()
        
        do {
            
            result = try context.fetch(fecthForDate) as! [Joke]
            result = result.sorted(by: {$0.jokeDateAdded?.compare(($1.jokeDateAdded as Date?)!) == .orderedDescending})
            
            self.jokes = result
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.allJokesTableView.reloadData()
            
//            for joke in result{
//                print(joke.jokeDateAdded!)
//                print(joke.jokeDescription!)
//            }
            
        } catch  {
            print("fetch for sorting by date failed")
        }
        
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


