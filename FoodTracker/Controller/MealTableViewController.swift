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
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var footerView: UIView!
    

    //MARK: Properties
    var filteredData : [Meal] = []
    var searchController = UISearchController(searchResultsController: nil)
    
    var hasNoData : Bool = true {
        didSet{
            hasNoData ? (tableView.tableFooterView = noDataView) : (tableView.tableFooterView = footerView)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        filteredData = DataService.shared.meals

        // xac dinh moi khi o text trong search bar thay doi
        searchController.searchResultsUpdater = self

        // set false giup table view khong bi che khuat
        searchController.dimsBackgroundDuringPresentation = false
        
//        searchController.searchBar.sizeToFit()
        
        // hien thi search bar o table view header
        tableView.tableHeaderView = searchController.searchBar
        
        //set bang true de search bar khong bi loi layout khi chay ung dung
        definesPresentationContext = true
        
        // chinh giao dien thanh search bar
//        searchController.searchBar.barTintColor = UIColor(red:52.0/255.0,green:200.0/255.0,blue:114.0/255.0,alpha:1.0)
//        searchController.searchBar.tintColor = UIColor.blue
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredData = DataService.shared.meals
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? (DataService.shared.meals) : (DataService.shared.meals.filter({ (meal: Meal) -> Bool in
                return meal.name.lowercased().contains(searchText.lowercased())
            }))
        }
        tableView.reloadData()
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
            if let index = DataService.shared.meals.index(of: filteredData[indexPath.row]) {
                DataService.shared.meals.remove(at: index)
            }
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            hasNoData = (filteredData.count == 0)
        }     
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mealDetailViewController = segue.destination as? MealViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let index = DataService.shared.meals.index(of: filteredData[indexPath.row]) {
                    mealDetailViewController.index = index
                }
            }
            
        }
    }
    
}
