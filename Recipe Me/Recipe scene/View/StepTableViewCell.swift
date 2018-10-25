//
//  StepTableViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {
  
  @IBOutlet weak var stepNumber: UILabel!
  @IBOutlet weak var stepImageView: UIImageView!
  @IBOutlet weak var stepLabel: UILabel!
  
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    heightConstraint.constant = 0
    stepNumber.text = nil
    stepImageView.image = nil
    stepLabel.text = nil
  }
  
  func setImage(image: UIImage?) {
    
    guard image != nil else { return }
    
    heightConstraint.constant = image!.size.height
    stepImageView.image = image
  }
}
