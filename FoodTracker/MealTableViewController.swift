//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by DungB96 on 2018/07/10.
//  Copyright © 2018 DungB96. All rights reserved.
//

import UIKit
import os.log


class MealTableViewController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                filteredData = meals.filter({ (text: Meal) -> Bool in
                    return text.name.lowercased().contains(searchText.lowercased())
                })
            } else {
                filteredData = meals
            }
        }
        tableView.reloadData()
    }
    

    //MARK: Properties
    var meals = [Meal]()
    var filteredData : [Meal]!
    var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    var hasNoData : Bool = true {
        didSet{
            hasNoData ? (tableView.tableFooterView = noDataView) : (tableView.tableFooterView = footerView)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Use the edit button item provided by table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved meals, otherwise load sample data
        if let savedMeals = loadMeals() {
             meals += savedMeals
        } else {
            //Load the sample data
            loadSampleMeals()
        }
      
        filteredData = meals
        
        // xac dinh moi khi o text trong search bar thay doi
        searchController.searchResultsUpdater = self
        
        // set false giup table view khong bi che khuat
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        
        // hien thi search bar o table view header
        tableView.tableHeaderView = searchController.searchBar
        
        //set bang true de search bar khong bi loi layout khi chay ung dung
        definesPresentationContext = true
        
        // chinh giao dien thanh search bar
        searchController.searchBar.barTintColor = UIColor(red:52.0/255.0,green:200.0/255.0,blue:114.0/255.0,alpha:1.0)
        searchController.searchBar.tintColor = UIColor.blue
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
        return filteredData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        //Fetches the appropriate meal for the data source layout.
        let meal = filteredData[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            filteredData.remove(at: indexPath.row)
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            hasNoData = filteredData.count == 0
            hasNoData = meals.count == 0
            if(filteredData.count == 0) {
                noDataView.isHidden = false
            }
           
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let mealDetailViewController = segue.destination as? MealViewController
        if segue.identifier == "ShowDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController?.meal = selectedMeal
            }
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal
                meals[selectedIndexPath.row] = meal
                filteredData = meals
                noDataView.isHidden = true
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                //Add a new meal
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                filteredData = meals
                noDataView.isHidden = true
                tableView.insertRows(at: [newIndexPath], with: .fade)
                
            }
            // Save the meals.
            saveMeals()
        }
    }
    

    //MARK: Private methods
    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        meals += [meal1, meal2, meal3]        
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    
}
