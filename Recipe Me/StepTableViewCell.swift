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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    stepImageView.image = nil
    stepLabel.text = nil
  }
}
