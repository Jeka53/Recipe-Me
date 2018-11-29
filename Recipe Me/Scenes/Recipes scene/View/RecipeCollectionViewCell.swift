//
//  RecipeCollectionViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageView.image = nil
    titleLabel.text = nil
    
    // appearance
    layer.cornerRadius = 6
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
    clipsToBounds = true
  }
}
