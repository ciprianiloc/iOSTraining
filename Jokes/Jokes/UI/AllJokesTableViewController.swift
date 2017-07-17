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

    
    //MARK: - variables and outlets
    
    @IBOutlet var allJokesTableView: UITableView!
    var jokes : [Joke] = []
    var categories : [String] = []
    var isSorted : [Bool] = [Bool]()
    var isSortedByDate : [Bool] = [Bool]()
    var jokesFromSection : [Joke] = [Joke]()
    var sortedJokes : [Joke] = [Joke]()
    var sortedJokesByDate : [Joke] = [Joke]()
    var rateButtonPressed : Bool = false
    var selectedSection : Int = 0
    var categoryForSortingView : String = ""
   
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

    // MARK: - Table view sections functions

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
        if categories.count>0{
                       return self.categories[section]
        }else{
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.selectedSection = section
        self.categoryForSortingView = self.categories[section]

       
        
        //NEW WAY OF DOING THINGS
        let sortingView = SortingView()
        sortingView.sectionFromView = self.selectedSection
        sortingView.categoryFromAllJokes = self.categoryForSortingView
        let sectionView = sortingView.loadViewFromNib()
        return sectionView
    }
    
    
   
    
    // MARK: - tableView cell functions
    
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
    
    //MARK: - auxiliary functions
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try jokes = context.fetch(Joke.fetchRequest())
        }catch {
            print("error while fetching data from CoreData")
        }
    }
    
    func getNumberOfJokesForCategory(category : String) -> Int{  //count the jokes for a specific category

        var countJokesForCategory = 0
       
        jokes = fetchJokes()
        
        for joke in jokes{
            if category == joke.jokeCategory{
                countJokesForCategory += 1
            }
        }
        
        return countJokesForCategory
        
        
        //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        //        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        do {
//            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
//            
//            for joke in jokes{
//                if category == joke.jokeCategory{
//                    countJokesForCategory += 1
//                }
//            }
//        } catch  {
//            print("fetching failed")
//        }
   
    }
    
    func fetchJokes() -> [Joke]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            jokes = try managedContext.fetch(fetchRequest) as! [Joke]
        } catch  {
            print("fetch failed")
        }
        
        return jokes
    }
    
    func getJokesFromSection(section: Int) -> [Joke]{
        var result : [Joke] = [Joke]()
        var finalResult : [Joke] = [Joke]()

        
        result = fetchJokes()
        
        for joke in result{
            if joke.jokeCategory == String(self.categories[section]){
                finalResult.append(joke)
            }
        }
        
        return finalResult  //all jokes from the section
        
        //        let fecthRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Joke")
        //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //
        //            do {
        //                result = try context.fetch(fecthRequest) as! [Joke]
        //
        //                for joke in result{
        //                    if joke.jokeCategory == String(self.categories[section]){
        //                        finalResult.append(joke)
        //                    }
        //                }
        //
        //            } catch  {
        //                print("fetched for a category failed")
        //            }
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
    
    
    func sortByRating(sender : Int){
        var result : [Joke] = [Joke]()
        result = self.getJokesFromSection(section: sender)
        result = result.sorted(by: {$0.jokeRating > $1.jokeRating})
        self.isSorted[sender] = true
        self.sortedJokes = result
      
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let indexSection = NSIndexSet(index: sender)
        self.allJokesTableView.reloadSections(indexSection as IndexSet, with: .fade)
        
       // self.rateButtonPressed = false

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
    
    //MARK: - buttons
    
    
    func ratingButtonPressed(sender : UIButton){
        self.rateButtonPressed = true
        sortByRating(sender: sender.tag)
        
    }
    
    func dateButtonPressed(sender : UIButton){
        self.rateButtonPressed = false
        sortByDate(sender: sender.tag)
    }
    
    @IBAction func addNewJokeButton(_ sender: Any) {
        let addJokeStoryboard = UIStoryboard(name: "AllJokes", bundle: nil)
        let addJokeVC = addJokeStoryboard.instantiateViewController(withIdentifier: "AddNewJokeViewController")
        self.present(addJokeVC, animated: true, completion: nil)
    }
    
    
    
}


