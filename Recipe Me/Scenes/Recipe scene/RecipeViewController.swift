//
//  RecipeViewController.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  // Cell identifiers
  let titlePhotoCell = "TitlePhotoCell"
  let stepCell = "StepCell"
  let ingridientsCell = "IngredientsCell"
  
  weak var managedContext = TabBarController.managedContext
  var fetchResultsController: NSFetchedResultsController<Recipe>!
  
  // Query parameter
  var recipeTitle: String!
  
  //TODO: delete if
  var imagesCache = [UIImage?]()
  var titleImageCache: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.alpha = 0
    title = recipeTitle
    navigationItem.largeTitleDisplayMode = .never
    tableView.rowHeight = UITableView.automaticDimension
    
    DispatchQueue.main.async {
      self.fetchSelectedRecipe()
    }
  }
  
  // refresh all ingridients
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      for ingridient in fetchResultsController.fetchedObjects?.first!.ingridients?.array as! [Ingredient] {
        ingridient.isPresent = false
      }
      
      let tableViewCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
      
      if let cell = tableViewCell as! IngredientsTableViewCell? {
        cell.tableView.reloadData()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    DispatchQueue.main.async {
      try! self.managedContext?.save()
    }
  }

  
  deinit {
    print("RecipeViewController was deinitialized")
  }
  
  func fetchSelectedRecipe() {
    let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    let selectedRecipePredicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.title), recipeTitle)
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Recipe.title), ascending: true)
    fetchRequest.predicate = selectedRecipePredicate
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: managedContext!,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: "recipe")
    do {
      try fetchResultsController.performFetch()
      let recipe = fetchResultsController.fetchedObjects?.first!
      let steps = recipe?.steps!.array as! [Step]
      let arrayOfData = steps.map { $0.image! as Data}
      let fullResImages = arrayOfData.map { UIImage(data: $0)!}
      imagesCache = fullResImages.map { $0.renderResizedImage(newWidth: UIScreen.main.bounds.width)}
      let imageData = recipe?.image as Data?
      if let imageData = imageData {
        let image = UIImage(data: imageData)
        titleImageCache = image?.renderResizedImage(newWidth: UIScreen.main.bounds.width)
      }
      tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
      self.tableView.reloadData()
      UIView.animate(withDuration: 0.2) {
        self.tableView.alpha = 1
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension RecipeViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard fetchResultsController != nil else { return 0 }
    
    if section == 0 {
      return 1
    }
    
    if section == 1 {
      return 1
    }
    
    if section == 2 {
      return fetchResultsController.fetchedObjects?.first?.steps?.count ?? 0
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let recipe = fetchResultsController.fetchedObjects?.first! else { return UITableViewCell() }
    
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: titlePhotoCell, for: indexPath) as! RecipeTitleTableViewCell
      cell.setImage(image: titleImageCache)
      cell.recipeTitleLabel.text = recipe.title
      cell.recipeTimeLabel.text = recipe.time < 60 ? String(recipe.time) + " min" : String(recipe.time / 60) + " h"
      cell.recipeDescriptionLabel.text = recipe.details
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: ingridientsCell, for: indexPath) as! IngredientsTableViewCell
      cell.ingridients = (recipe.ingridients?.array as! [Ingredient])
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: stepCell, for: indexPath) as! StepTableViewCell
      let step = recipe.steps?.object(at: indexPath.row) as! Step
      
      cell.setImage(image: self.imagesCache[indexPath.row])
      cell.stepLabel.text = step.details
      cell.stepNumber.text = String(indexPath.row + 1)
      return cell
    default:
      return UITableViewCell()
    }
  }
}

// image resizer
extension UIImage {
  func renderResizedImage(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    // round the Height of an image to avoid subpixel rendering
    let newHeight = ceil(self.size.height * scale)
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let image = renderer.image { (context) in
      self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
    }
    return image
  }
}
