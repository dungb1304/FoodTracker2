//
//  DataService.swift
//  FoodTracker
//
//  Created by DungB96 on 2018/07/17.
//  Copyright © 2018 DungB96. All rights reserved.
//
import UIKit

class DataService {
    static let shared: DataService = DataService()
    
    private var _meals: [Meal]?
    
    var meals:[Meal] {
        get {
            if _meals == nil {
                loadSampleMeals()
            }
            return _meals ?? []
        }
        set {
            _meals = newValue
        }
    }
    
    private func loadSampleMeals() {
        _meals = []
        guard let capreseSalad = Meal(name: "Caprese Salad", photo: #imageLiteral(resourceName: "meal1"), rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        guard let chickenAndPotatoes = Meal(name: "Chicken and Potatoes", photo: #imageLiteral(resourceName: "meal2"), rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        guard let pastawithMeatballs = Meal(name: "Pasta with Meatballs", photo: #imageLiteral(resourceName: "meal3"), rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        _meals?.append(chickenAndPotatoes)
        _meals?.append(capreseSalad)
        _meals?.append(pastawithMeatballs)
    }
    
    func newMeal(meal : Meal){
        _meals?.append(meal)
    }
}
