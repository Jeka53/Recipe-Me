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
  
  
  weak var managedContext = TabBarController.managedContext
  var fetchResultsController: NSFetchedResultsController<Recipe>!
  
  // Query parameter
  var recipeTitle: String!
  
  //TODO: delete if
  var arrayOfImages = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = recipeTitle
    
    fetchSelectedRecipe()
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
      arrayOfImages = fullResImages.map { $0.renderResizedImage(newWidth: 320)}
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension RecipeViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return 1
    }
    
    if section == 1 {
      return fetchResultsController.fetchedObjects?.first?.steps?.count ?? 0
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let recipe = fetchResultsController.fetchedObjects?.first! else { return UITableViewCell() }
    
    switch indexPath.section {
//    case 0:
//      let cell = tableView.dequeueReusableCell(withIdentifier: titlePhotoCell, for: indexPath) as! TitlePhotoTableViewCell
//      let imageData = recipe.image as Data?
//      if let imageData = imageData {
//        cell.titleImageView.image = UIImage(data: imageData)
//      }
//      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: stepCell, for: indexPath) as! StepTableViewCell
      let step = recipe.steps?.object(at: indexPath.row) as! Step
//      let imageData = step.image as Data?
//      if let imageData = imageData {
//        cell.stepImageView.image = UIImage(data: imageData)
//      }
      cell.stepImageView.image = self.arrayOfImages[indexPath.row]
      
      cell.stepLabel.text = step.details
      cell.stepNumber.text = String(indexPath.row + 1)
    default:
      return UITableViewCell()
    }
    
    return UITableViewCell()
  }
  
}

// image resizer
extension UIImage {
  func renderResizedImage(newWidth: CGFloat) -> UIImage {
    let scale = newWidth / self.size.width
    let newHeight = self.size.height * scale
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    
    let image = renderer.image { (context) in
      self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
    }
    return image
  }
}
