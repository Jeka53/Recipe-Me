//
//  CreateCategoryViewController.swift
//  Recipe Me
//
//  Created by Jora on 10/26/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CreateCategoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var textField: UITextField!
  
  @IBAction func createCategory(_ sender: UIButton) {
    
    guard textField.text != "" else { return }
    
    categoryTitleForNewRecipe = textField.text!
    
    //TODO: complete
    guard categoryNames.contains(textField.text!) == false else {
      performSegue(withIdentifier: segueIdentifier, sender: self)
      return
    }
    
    let newCategory = Category(context: managedContext!)
    newCategory.name = textField.text!
    newCategory.numberOfRecipes = 0
    
    do {
      try managedContext?.save()
    } catch {
      print(error.localizedDescription)
    }
    
    performSegue(withIdentifier: segueIdentifier, sender: self)
  }
  
  @IBAction func newSegmentSelected(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      contentView.isHidden = true
      separatorView.isHidden = false
      contentView.endEditing(true)
    default:
      contentView.isHidden = false
      separatorView.isHidden = true
    }
  }
  
  @IBAction func dismissViewController(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func resignTextField(_ sender: UITapGestureRecognizer) {
    self.textField.resignFirstResponder()
  }
  
  weak var managedContext = TabBarController.managedContext
  
  let segueIdentifier = "toCreateTitleViewController"
  
  var categoryNames: [String] = []
  var amountOfRecipesInCategory: [String] = []
  
  var categoryTitleForNewRecipe: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    DispatchQueue.main.async {
      self.loadExistingCategories()
    }
  }
  
  deinit {
    print("CreateCategoryViewController was deinitialized")
  }
  
  func loadExistingCategories() {
    let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Category")
    fetchRequest.resultType = .dictionaryResultType
    fetchRequest.propertiesToFetch = ["name", "numberOfRecipes"]
    let sortDescriptor = NSSortDescriptor(key: #keyPath(Category.name), ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    do {
      let results = try managedContext?.fetch(fetchRequest)
      guard results != nil else { return }
      categoryNames = results!.map { $0["name"] as! String }
      amountOfRecipesInCategory = results!.map { ($0["numberOfRecipes"] as! NSNumber).stringValue }
      tableView.reloadData()
    } catch {
      print(error.localizedDescription)
    }
    
  }

  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard segue.identifier == segueIdentifier else {
      return
    }
    
    let nextVC = segue.destination as! CreateTitleViewController
    nextVC.categoryTitle = categoryTitleForNewRecipe
  }
}

// MARK: - UITableViewDataSource
extension CreateCategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryNames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.textColor = UIColor(white: 0.25, alpha: 1)
    cell.textLabel?.text = categoryNames[indexPath.row] + " (" + amountOfRecipesInCategory[indexPath.row] + ")"
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CreateCategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let categoryName = categoryNames[indexPath.row]
    let alert = UIAlertController(title: "Create in Category?", message: """
      Do you want to create a new recipe inside existing category:
      "\(categoryName)"?
      """,
      preferredStyle: .alert)
    let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let action2 = UIAlertAction(title: "Create", style: .default) { (action) in
      self.categoryTitleForNewRecipe = self.categoryNames[indexPath.row]
      self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    alert.addAction(action)
    alert.addAction(action2)
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}


