//
//  NewIngredientTableViewCell.swift
//  RemindersTableView
//
//  Created by Jora on 11/6/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class NewIngredientTableViewCell: UITableViewCell {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var customImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    textField.text = ""
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
    
}
