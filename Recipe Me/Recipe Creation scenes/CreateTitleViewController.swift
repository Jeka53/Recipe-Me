//
//  CreateTitleViewController.swift
//  Recipe Me
//
//  Created by Jora on 10/26/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CreateTitleViewController: UIViewController {
  
  @IBAction func resignFirstResponders(_ sender: UITapGestureRecognizer) {
    titleTextField.resignFirstResponder()
    timeTextField.resignFirstResponder()
    textView.resignFirstResponder()
  }
  
  @IBAction func createRecipe(_ sender: UIBarButtonItem) {
    
    titleTextField.resignFirstResponder()
    timeTextField.resignFirstResponder()
    textView.resignFirstResponder()
   
    
    let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Category.name), categoryTitle)
    
    do {
      // get current Category
      let categories = try managedContext?.fetch(fetchRequest)
      guard categories != nil, categories?.first != nil else { return }
      let category = categories!.first!
      
      // check if Recipe already exists
      let filtered = category.recipes?.filtered(using: NSPredicate(format: "%K == %@", #keyPath(Recipe.title), titleTextField.text!))
      if filtered!.count > 0 {
        let recipe = filtered?.firstObject! as! Recipe
          let time = Int16(timeTextField.text!)
          if let time = time {
            recipe.time = time
          }
          recipe.details = textView.text!
          
          do {
            try managedContext?.save()
            recipeTitle = titleTextField.text!
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
          } catch {
            print(error.localizedDescription)
          }
        return
      }
      
      // create Recipe
      let newRecipe = Recipe(context: managedContext!)
      newRecipe.category = category
      newRecipe.title = titleTextField.text!
      let time = Int16(timeTextField.text!)
      if let time = time {
        newRecipe.time = time
      }
      newRecipe.details = textView.text!
      
      category.numberOfRecipes += 1
      
      try managedContext?.save()
      recipeTitle = titleTextField.text!
      self.performSegue(withIdentifier: segueIdentifier, sender: self)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var timeTextField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  let keyboardHeightPortrait = 216
  let segueIdentifier = "toCreateIngredientsViewController"
  
  weak var managedContext = TabBarController.managedContext
  var categoryTitle: String!
  var recipeTitle: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(activateNextButton), name: UITextField.textDidChangeNotification, object: titleTextField)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier else { return }
    
    let destinationVC = segue.destination as! CreateIngredientsViewController
    destinationVC.recipeTitle = recipeTitle
  }
 
  
  deinit {
    print("CreateTitleViewController was deinitialized")
  }
  
  @objc func activateNextButton() {
    nextBarButtonItem.isEnabled = titleTextField.text!.count > 1
  }
}

// MARK: - UITextViewDelegate
extension CreateTitleViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeightPortrait), animated: true)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
}

// MARK: - UITextFieldDelegate
extension CreateTitleViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

