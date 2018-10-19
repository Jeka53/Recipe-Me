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
  
  
  // MARK: - Lifecycle
    override func viewDidLoad() {
      super.viewDidLoad()
      
      managedContext = TabBarController.managedContext
      
      let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
      let sortDescriptor = NSSortDescriptor(key: #keyPath(Category.name), ascending: true)
      fetchRequest.sortDescriptors = [sortDescriptor]
      
      fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
      do {
        try fetchResultsController.performFetch()
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
    return fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
    let category = fetchResultsController.object(at: indexPath)
    let imageData = (category.recipes?.firstObject as! Recipe).image as Data?
    if let imageData = imageData {
      cell.imageView.image = UIImage(data: imageData)
    }
    cell.categoryNameLabel.text = category.name
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
    return CGSize(width: size, height: size)
  }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: segueIdentifier, sender: collectionView)
  }
}
