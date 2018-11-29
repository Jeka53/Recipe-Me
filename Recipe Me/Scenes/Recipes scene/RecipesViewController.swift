//
//  RecipesViewController.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class RecipesViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let numbersOfItemsInRow = 2
  let recipeCellIdentifier = "RecipeCell"
  
  let segueIdentifier = "toRecipe"
  
  var category: String!
  var fetchResultsController: NSFetchedResultsController<Recipe>!
  weak var managedContext = TabBarController.managedContext
  var imagesCache = [UIImage?]()
  
  var cellSize: CGFloat? {
    didSet {
      self.imagesCache = self.imagesCache.map{$0?.renderResizedImage(newWidth: cellSize!)}
      collectionView.reloadData()
    }
  }
  
  lazy var selectedCategoryRecipesPredicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.category.name), category)
  lazy var sortDescriptor = NSSortDescriptor(key: #keyPath(Recipe.title), ascending: true)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = category
    
    DispatchQueue.main.async {
      self.fetchSelectedCatagoryRecipes()
    }
  }
  
  deinit {
    print("RecipesViewController was deinitialized")
  }
    
  func fetchSelectedCatagoryRecipes() {
    imagesCache = []
    
    let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
    fetchRequest.predicate = selectedCategoryRecipesPredicate
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                        managedObjectContext: managedContext!,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
    
    do {
      try fetchResultsController.performFetch()
      let recipes = fetchResultsController.fetchedObjects
      if let recipes = recipes {
        recipes.forEach { recipe in
          if let imageData = recipe.image as Data? {
            imagesCache.append(UIImage(data: imageData))
          } else {
            imagesCache.append(UIImage(named: "cameraIcon"))
          }
        }
      }
      // cellSize is not set by sizeForItemAt when you dissmiss to self
      if cellSize != nil {
        self.imagesCache = self.imagesCache.map{$0?.renderResizedImage(newWidth: cellSize!)}
      }
      UIView.transition(with: collectionView,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations: { self.collectionView.reloadData() }
      )
    } catch {
      print(error.localizedDescription)
    }
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier else { return }
    
    let destinationVC = segue.destination as! RecipeViewController
    let indexPath = collectionView.indexPathsForSelectedItems!.first!
    destinationVC.recipeTitle = fetchResultsController.fetchedObjects?[indexPath.row].title
  }
 

}

// MARK: - UICollectionViewDataSource
extension RecipesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard fetchResultsController != nil else { return 0 }
    return fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipeCellIdentifier, for: indexPath) as! RecipeCollectionViewCell
    let recipe = fetchResultsController.object(at: indexPath)
    cell.imageView.image = imagesCache[indexPath.row]
    cell.titleLabel.text = recipe.title
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecipesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let totalSpace = flowLayout.sectionInset.left
      + flowLayout.sectionInset.right
      + (flowLayout.minimumInteritemSpacing * CGFloat(numbersOfItemsInRow - 1))
    let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numbersOfItemsInRow))
    if cellSize == nil {
      cellSize = CGFloat(size)
    }
    return CGSize(width: size, height: size)
  }
}

// MARK: - UICollectionViewDelegate
extension RecipesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: segueIdentifier, sender: collectionView)
  }
}
