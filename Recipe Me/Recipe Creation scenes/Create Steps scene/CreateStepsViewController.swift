//
//  CreateStepsViewController.swift
//  Recipe Me
//
//  Created by Jora on 11/15/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CreateStepsViewController: UIViewController {
  
  @IBAction func createSteps(_ sender: UIBarButtonItem) {
    
    guard let recipe = self.recipe else { return }
    recipe.steps = []
    imageWithDescriptionUploader.collectionView.steps.forEach { step in
      if (step.image != nil && step.image!.isEqual(UIImage(named: "cameraIcon")) == false)
      || step.text!.count > 1 {
        let nsStep = Step(context: managedContext!)
        nsStep.details = step.text
        let imageData = step.image?.pngData() as NSData?
        nsStep.image = imageData
        recipe.addToSteps(nsStep)
      }
    }
    
    do {
      try managedContext?.save()
    } catch {
      print(error.localizedDescription)
    }
    
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
  
  @IBOutlet weak var nextButtonItem: UIBarButtonItem!
  
  @IBOutlet var imageWithDescriptionUploader: ImageWithDescriptionUploader!
  
  weak var managedContext = TabBarController.managedContext
  var recipeTitle: String!
  var recipe: Recipe!
  let segueIdentifier = "toCreateRecipeImageViewController"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let contentView = Bundle.main.loadNibNamed("ImageWithDescriptionUploader", owner: self, options: nil)?.first as! UIView
    view = contentView
    
    imageWithDescriptionUploader.collectionView.collectionWasReloaded = { [weak self] numberOfSteps in
      self?.nextButtonItem.isEnabled = numberOfSteps > 1
    }
    
    DispatchQueue.main.async {
      self.fetchSteps()
    }
  }
  
  deinit {
    print("CreateStepsViewController was deinitialized")
  }
  
  // MARK: - Methods
  func fetchSteps() {
    let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
    let recipeByNamePredicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.title), recipeTitle)
    fetchRequest.predicate = recipeByNamePredicate
    
    do {
      let recipes = try managedContext?.fetch(fetchRequest)
      guard let recipe = recipes?.first, let nsSteps = recipe.steps else {return}
      self.recipe = recipe
      if nsSteps.count > 0 {
        let steps = nsSteps.array as! [Step]
        var fetchedSteps = [RecipeStep]()
        steps.forEach { step in
          var parsedStep = RecipeStep(image: nil, text: step.details)
          let imageData = step.image as Data?
          if let imageData = imageData {
            let image = UIImage(data: imageData)
            parsedStep.image = image
          }
          fetchedSteps.append(parsedStep)
        }
        
        fetchedSteps.append(RecipeStep(image: UIImage(named: "cameraIcon"), text: ""))
        imageWithDescriptionUploader.collectionView.steps = fetchedSteps
        imageWithDescriptionUploader.collectionView.reloadData()
        imageWithDescriptionUploader.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        imageWithDescriptionUploader.textView.text = fetchedSteps.first!.text
        imageWithDescriptionUploader.imageView.image = fetchedSteps.first!.image
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
    
    let nextVC = segue.destination as! CreateRecipeImageViewController
    nextVC.recipeTitle = recipeTitle
  }
  
}
