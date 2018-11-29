//
//  IngredientTableViewCell.swift
//  RemindersTableView
//
//  Created by Jora on 11/5/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var deleteButton: UIButton!
  
  @IBAction func deleteCurrentCell(_ sender: UIButton) {
    deleteCellCallback?(self)
  }
  
  var deleteCellCallback: ((UITableViewCell) -> Void)!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textField.text = ""
    textField.isUserInteractionEnabled = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      textField.isUserInteractionEnabled = true
      textField.becomeFirstResponder()
    } else {
      textField.isUserInteractionEnabled = false
      textField.resignFirstResponder()
    }
  }
  
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
    let buttonRect = deleteButton.convert(deleteButton.bounds.insetBy(dx: -8, dy: -8), to: self)
    if buttonRect.contains(point) {
      return deleteButton
    }
    
    return super.hitTest(point, with: event)
  }

}
