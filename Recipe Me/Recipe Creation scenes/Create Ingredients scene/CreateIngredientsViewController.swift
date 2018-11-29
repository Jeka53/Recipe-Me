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
    recipe.ingridients = []
    tableView.ingridients.forEach { ingridientString in
      let ingridient = Ingredient(context: managedContext!)
      ingridient.details = ingridientString
      ingridient.isPresent = false
      recipe.addToIngredients(ingridient)
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
      tableView.tableViewReloadedCallback = { [weak self] ingridients in
        self?.nextBarButtonItem.isEnabled = ingridients.count > 1
      }
    }
  }
  
  @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
  
  weak var managedContext = TabBarController.managedContext
  
  var recipeTitle: String!
  var ingridients: [Ingredient] = []
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
      guard let recipe = recipes?.first, let nsIngredients = recipe.ingridients else {return}
      self.recipe = recipe
      if nsIngredients.count > 0 {
        ingridients = nsIngredients.array as! [Ingredient]
        tableView.ingridients =  ingridients.map{$0.details!}
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
