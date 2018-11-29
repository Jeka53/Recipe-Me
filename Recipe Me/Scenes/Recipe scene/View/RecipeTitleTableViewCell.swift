//
//  TitlePhotoTableViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class RecipeTitleTableViewCell: UITableViewCell {
  
  @IBOutlet weak var recipeTitleImageView: UIImageView!
  @IBOutlet weak var recipeTitleLabel: UILabel!
  @IBOutlet weak var recipeTimeLabel: UILabel!
  @IBOutlet weak var recipeDescriptionLabel: UILabel!
  
  @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    recipeTitleImageView.image = nil
    imageViewHeightConstraint.constant = 0
  }
  
  func setImage(image: UIImage?) {
    
    guard image != nil else { return }
    
    imageViewHeightConstraint.constant = image!.size.height
    recipeTitleImageView.image = image
  }

}
