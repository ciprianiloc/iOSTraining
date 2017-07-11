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
    var isSorted : [Bool] = [Bool]()
    var isSortedByDate : [Bool] = [Bool]()
    var sortedJokesByRating : [Joke] = [Joke]()
    var selectedSection : Int = 0
    var jokesFromSection : [Joke] = [Joke]()
    var sortedJokes : [Joke] = [Joke]()
    var sortedJokesByDate : [Joke] = [Joke]()
    var rateButtonPressed : Bool = false
    
    //var dateButton : UIButton = UIButton()//(frame: CGRect(x: 310, y: 0, width: 100, height: 20))
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJokeButton(_:)))
        allJokesTableView.delegate = self
        allJokesTableView.dataSource = self
     
    }
//
    
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
                if let newCategory = joke.jokeCategory{
                    if !categories.contains(newCategory){
                        categories.append(newCategory)
                        isSorted.append(false)
                        isSortedByDate.append(false)
                    }
                }
            }
        
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = getNumberOfJokesForCategory(category: categories[section])
        return number
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //self.selectedSection = indexPath.section
        if categories.count>0{
            return self.categories[section]
        }else{
            return ""
        }
        
//        let indexSection = NSIndexSet(index: self.selectedSection)
//        self.allJokesTableView.reloadSections(indexSection as IndexSet, with: .fade)
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
        
        let dateButton = UIButton(frame: CGRect(x: 314, y: 0, width: 100, height: 20))
        dateButton.setTitle("Date added", for: .normal)
        dateButton.setTitleColor(UIColor.black, for: .normal)
        dateButton.backgroundColor = UIColor(red: 79/255, green: 233/255, blue: 83/255, alpha: 0.5)
        dateButton.layer.cornerRadius = 5
        dateButton.layer.borderWidth = 2
        dateButton.layer.borderColor = UIColor.black.cgColor
        dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        dateButton.addTarget(self, action: #selector(dateButtonPressed(sender:)), for: .touchUpInside)
        dateButton.tag = section
        
        
   
        
        let ratingButton : UIButton = UIButton(frame: CGRect(x: 240, y: 0, width: 60, height: 20))
        ratingButton.setTitle("Rating",for:.normal)
        ratingButton.setTitleColor(UIColor.black, for: .normal)
        ratingButton.backgroundColor = UIColor(red: 79/255, green: 233/255, blue: 83/255, alpha: 0.5)
        ratingButton.layer.cornerRadius = 5
        ratingButton.layer.borderWidth = 2
        ratingButton.layer.borderColor = UIColor.black.cgColor
        ratingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        ratingButton.addTarget(self, action: #selector(ratingButtonPressed(sender:)), for: .touchUpInside)
        ratingButton.tag = section
        
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
        
        if rateButtonPressed{
            if !isSorted[indexPath.section]{
                self.jokesFromSection = getJokesFromSection(section: indexPath.section)
            }else{
                self.jokesFromSection = getJokesFromSortedSection(section: indexPath.section)
            }
        }
        else{
            if !isSortedByDate[indexPath.section]{
                self.jokesFromSection = getJokesFromSection(section: indexPath.section)
            }else{
                self.jokesFromSection = getJokesFromSortedSectionByDate(section: indexPath.section)
            }
        }
        let joke = jokesFromSection[indexPath.row]
        cell.jokeLabel.text = String(describing: joke.jokeDescription!)
        cell.ratingStarsView.rating = jokesFromSection[indexPath.row].jokeRating

 
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailJoke") as? DetailJokeViewController
        
        if rateButtonPressed{
            if !isSorted[indexPath.section]{
                self.jokesFromSection = getJokesFromSection(section: indexPath.section)
            }else{
                self.jokesFromSection = getJokesFromSortedSection(section: indexPath.section)
            }
        }else{
            if !isSortedByDate[indexPath.section]{
                self.jokesFromSection = getJokesFromSection(section: indexPath.section)
            }else{
                self.jokesFromSection = getJokesFromSortedSectionByDate(section: indexPath.section)
            }
            
        }
        detailView?.selectedJoke = String(describing: jokesFromSection[indexPath.row].jokeDescription!)
        detailView?.selectedCategory = String(describing: jokesFromSection[indexPath.row].jokeCategory!)
        detailView?.getAJoke(withObjectID: jokesFromSection[indexPath.row].objectID)

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController?.pushViewController(detailView!, animated: true)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if editingStyle == .delete{
            //let joke = jokes[indexPath.row]
            self.jokesFromSection = getJokesFromSection(section: indexPath.section)
            let joke = self.jokesFromSection[indexPath.row]
            context.delete(joke)
        
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                try jokesFromSection = context.fetch(Joke.fetchRequest())
            } catch  {
                print("fecth failed on DELETE")
            }
        }
        allJokesTableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
        allJokesTableView.reloadData()
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
    
    func getJokesFromSection(section: Int) -> [Joke]{
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
    
    
    
    func getJokesFromSortedSection(section: Int) -> [Joke]{
        var result : [Joke] = [Joke]()
        
        result = self.getJokesFromSection(section: section)
        result = result.sorted(by: {$0.jokeRating > $1.jokeRating})
        
        if isSorted[section]{
            return result
        }else{
            return getJokesFromSection(section:section)
        }
    }
    
    func getJokesFromSortedSectionByDate(section : Int) -> [Joke]{
        var result : [Joke] = [Joke]()
        
        result = self.getJokesFromSection(section: section)
        result = result.sorted(by: {$0.jokeDateAdded?.compare(($1.jokeDateAdded as Date?)!) == .orderedDescending})
        
        if isSortedByDate[section]{
            return result
        }else{
            return getJokesFromSection(section: section)
        }
    }
    
    
    @IBAction func addNewJokeButton(_ sender: Any) {
        let addJokeStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let addJokeVC = addJokeStoryboard.instantiateViewController(withIdentifier: "AddNewJokeViewController")
        self.present(addJokeVC, animated: true, completion: nil)
    }
    
    func sortByRating(sender : Int){
        var result : [Joke] = [Joke]()
        result = self.getJokesFromSection(section: sender)
        result = result.sorted(by: {$0.jokeRating > $1.jokeRating})
        self.isSorted[sender] = true
        self.sortedJokes = result
      
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let indexSection = NSIndexSet(index: sender)
        self.allJokesTableView.reloadSections(indexSection as IndexSet, with: .fade)
        
        self.rateButtonPressed = false

    }
    
    func sortByDate(sender: Int){
        var result : [Joke] = [Joke]()
        
        result = self.getJokesFromSection(section: sender)
        result = result.sorted(by: {$0.jokeDateAdded?.compare(($1.jokeDateAdded as Date?)!) == .orderedDescending})
        
        self.isSortedByDate[sender] = true
        self.sortedJokesByDate = result
        
        for joke in result{
            print(joke.jokeDateAdded!)
            print(joke.jokeDescription!)
        }

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let indexSection = NSIndexSet(index: sender)
        self.allJokesTableView.reloadSections(indexSection as IndexSet, with: .fade)
    }
    
    func ratingButtonPressed(sender : UIButton){
        self.rateButtonPressed = true
        sortByRating(sender: sender.tag)
    }
    
    func dateButtonPressed(sender : UIButton){
        sortByDate(sender: sender.tag)
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


