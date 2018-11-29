//
//  RecipesViewController.swift
//  Recipe Me
//
//  Created by Jora on 10/18/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
  
  let categoryCellIdentifier = "CategoryCell"
  let numbersOfItemsInRow = 2
  let segueIdentifier = "toRecipes"
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var fetchResultsController: NSFetchedResultsController<Category>!
  var managedContext: NSManagedObjectContext!
  var imagesCache = [UIImage?]()
  
  // resize cell image to fit imageView size
  var cellSize: CGFloat? {
    didSet {
      self.imagesCache = self.imagesCache.map{$0?.renderResizedImage(newWidth: cellSize!)}
      collectionView.reloadData()
    }
  }
  
  
  // MARK: - Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      
      managedContext = TabBarController.managedContext
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    DispatchQueue.main.async {
      self.fetchCategories()
    }
  }
  
  // MARK: - Methods
  func fetchCategories() {
    imagesCache = []
    
    let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Category.name), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    do {
      try fetchResultsController.performFetch()
      // resize and cache images
      let categories = fetchResultsController.fetchedObjects
      if let categories = categories {
        categories.forEach { category in
          if let recipe = category.recipes?.firstObject as! Recipe? {
            if let imageData = recipe.image as Data? {
              imagesCache.append(UIImage(data: imageData))
            } else {
              imagesCache.append(UIImage(named: "cameraIcon"))
            }
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
      print("\(error.localizedDescription)")
    }
  }
  
  // MARK: - Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier else { return }
    
    let destinationVC = segue.destination as! RecipesViewController
    let selectedIndex = collectionView.indexPathsForSelectedItems!.first!
    destinationVC.category = fetchResultsController.fetchedObjects?[selectedIndex.row].name!
  }
}

// MARK: - UICollectionViewDataSource
extension CategoriesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard fetchResultsController != nil else { return 0 }
    return fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
    let category = fetchResultsController.object(at: indexPath)
    
    cell.imageView.image = imagesCache[indexPath.row]
    
    cell.categoryNameLabel.text = category.name
    
    //TODO: plural forms
    cell.categoryCountLabel.text = String(category.numberOfRecipes) + " recipes"
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
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
extension CategoriesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: segueIdentifier, sender: collectionView)
  }
}
