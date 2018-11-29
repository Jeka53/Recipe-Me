//
//  ImageCollectionViewCell.swift
//  ImageWithDescriptionUploader
//
//  Created by Jora on 11/9/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var numberLabel: UILabel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    backgroundColor = nil
    numberLabel.textColor = .lightGray
  }
  
  override var isSelected: Bool {
    didSet {
      backgroundColor = isSelected ? .lightGray : nil
      numberLabel.textColor = isSelected ? .white : .lightGray
    }
  }
}
