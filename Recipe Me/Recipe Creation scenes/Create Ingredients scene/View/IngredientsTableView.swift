//
//  IngredientsTableView.swift
//  IngredientsTableView
//
//  Created by Jora on 11/6/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class IngredientsTableView: UITableView {
  
  var ingredients: [String] = [] {
    didSet {
      // do not reload table view when textView value changed
      if oldValue.count != ingredients.count {
        reloadData()
        tableViewReloadedCallback?(ingredients)
      }
    }
  }
  
  var tableViewReloadedCallback: (([String]) -> Void)?
  
  let ingredientCellIdentifier = "IngredientCell"
  let newIngredientCellIdentifier = "NewIngredientCell"
  
  var selectedIndexPath: IndexPath!

  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.register(UINib(nibName: "IngredientTableViewCell", bundle: nil), forCellReuseIdentifier: ingredientCellIdentifier)
    self.register(UINib(nibName: "NewIngredientTableViewCell", bundle: nil), forCellReuseIdentifier: newIngredientCellIdentifier)
    
    dataSource = self
    delegate = self
  }
  
  override func reloadData() {
    super.reloadData()
    
    selectCell(indexPath: IndexPath(row: 0, section: 1))
  }

}

// MARK: - UITableViewDataSource
extension IngredientsTableView: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if section == 0 {
      return ingredients.count
    }
    
    if section == 1 {
      return 1
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: ingredientCellIdentifier, for: indexPath) as! IngredientTableViewCell
      cell.textField.delegate = self
      cell.textField.text = ingredients[indexPath.row]
      cell.deleteCellCallback = { [weak self] cell in
        if let indexPath = tableView.indexPath(for: cell) {
          self?.ingredients.remove(at: indexPath.row)
        }
      }
      return cell
    }
    
    if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: newIngredientCellIdentifier, for: indexPath) as! NewIngredientTableViewCell
      cell.textField.delegate = self
      //selectCell(indexPath: indexPath)
      return cell
    }
    
    return UITableViewCell()
  }
}

// MARK: - UITableViewDelegate
extension IngredientsTableView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndexPath = indexPath
    //selectCell(indexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    // existing cell
    if indexPath.section == 0 {
      let cell = tableView.cellForRow(at: indexPath) as! IngredientTableViewCell
      if cell.textField.text! == "" {
        ingredients.remove(at: indexPath.row)
      } else {
        self.ingredients[indexPath.row] = cell.textField.text!
      }
      return
    }
    
    // new cell
//    if indexPath.section == 1 {
//      let cell = tableView.cellForRow(at: indexPath) as! NewIngredientTableViewCell
//      createNewCell(indexPath: indexPath, textField: cell.textField)
//    }
  }
}


// MARK: - UITextFieldDelegate
extension IngredientsTableView: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    guard selectedIndexPath != nil else { return true }
    
    
    // Existing cell
    if selectedIndexPath.section == 0 {
      // existing cell is not empty
      guard textField.text == "" else {
        ingredients[selectedIndexPath.row] = textField.text!
        self.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        if selectedIndexPath.row == ingredients.count - 1 {
          selectCell(indexPath: IndexPath(row: 0, section: 1))
        } else {
          selectCell(indexPath: IndexPath(row: selectedIndexPath.row + 1, section: 0))
        }
        return true
      }
      // existing cell is empty
      ingredients.remove(at: selectedIndexPath.row)
      return true
    }
    
    
    // New cell
    if selectedIndexPath.section == 1 {
      createNewCell(indexPath: selectedIndexPath, textField: textField)
    }
    
    return true
  }
  
}


// MARK: - Cell selection logic
extension IngredientsTableView {
  
  // 1. Select cell
  private func selectCell(indexPath: IndexPath) {
    selectedIndexPath = indexPath
    self.selectRow(at: indexPath, animated: true, scrollPosition: .none)
  }
  
  // 2. Deselect cell
  private func deselectCell(indexPath: IndexPath) {
    self.deselectRow(at: indexPath, animated: true)
  }
  
  // 3. Create cell
  private func createNewCell(indexPath: IndexPath, textField: UITextField) {
    
    guard textField.text != "" else {
      deselectCell(indexPath: selectedIndexPath)
      return
    }
    
    ingredients.append(textField.text!)
    textField.text! = ""
  }
}
