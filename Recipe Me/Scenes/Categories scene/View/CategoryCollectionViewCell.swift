//
//  CategoryCollectionViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/18/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var categoryNameLabel: UILabel!
  
  @IBOutlet weak var categoryCountLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    imageView.image = nil
    categoryNameLabel.text = nil
    categoryCountLabel.text = nil
    
    // appearance
    layer.cornerRadius = 6
    layer.borderWidth = 0.5
    layer.borderColor = UIColor.lightGray.cgColor
    clipsToBounds = true
  }
}
