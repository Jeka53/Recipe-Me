//
//  TitlePhotoTableViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/19/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class TitlePhotoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleImageView.image = nil
  }

}
