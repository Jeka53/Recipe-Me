//
//  CreateIngredientsViewController.swift
//  Recipe Me
//
//  Created by Jora on 11/7/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CreateIngredientsViewController: UIViewController {
  
  @IBAction func createIngredients(_ sender: UIBarButtonItem) {
    guard let recipe = self.recipe else { return }
    recipe.ingredients = []
    tableView.ingredients.forEach { ingredientString in
      let ingredient = Ingredient(context: managedContext!)
      ingredient.details = ingredientString
      ingredient.isPresent = false
      recipe.addToIngredients(ingredient)
    }
    
    do {
      try managedContext?.save()
    } catch {
      print(error.localizedDescription)
    }
    
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
  
  @IBOutlet weak var tableView: IngredientsTableView! {
    didSet {
      tableView.tableViewReloadedCallback = { [weak self] ingredients in
        self?.nextBarButtonItem.isEnabled = ingredients.count > 1
      }
    }
  }
  
  @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
  
  weak var managedContext = TabBarController.managedContext
  
  var recipeTitle: String!
  var ingredients: [Ingredient] = []
  var recipe: Recipe!
  let segueIdentifier = "toCreateStepsViewController"
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // FIXME: In ViewDidLoad this code causes strange animation bug, probably because keyboard animation is happening during transition between View Controllers
    DispatchQueue.main.async {
      self.fetchIngredients()
    }
  }
  
  deinit {
    print("CreateIngredientsViewController was deinitialized")
  }
  
  // MARK: - Methods
  func fetchIngredients() {
    let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
    let recipeByNamePredicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.title), recipeTitle)
    fetchRequest.predicate = recipeByNamePredicate
    
    do {
      let recipes = try managedContext?.fetch(fetchRequest)
      guard let recipe = recipes?.first, let nsIngredients = recipe.ingredients else {return}
      self.recipe = recipe
      if nsIngredients.count > 0 {
        ingredients = nsIngredients.array as! [Ingredient]
        tableView.ingredients =  ingredients.map{$0.details!}
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard segue.identifier == segueIdentifier else {
      return
    }
    
    let nextVC = segue.destination as! CreateStepsViewController
    nextVC.recipeTitle = recipeTitle
    
  }
}
