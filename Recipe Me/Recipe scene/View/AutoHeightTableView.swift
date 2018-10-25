//
//  AutoFrameHeightTableView.swift
//  Recipe Me
//
//  Created by Jora on 10/25/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

/// This UITableView subclass has intrinsicContentSize to give a possibility to AutoLayout to detect a height of a table view
class AutoHeightTableView: UITableView {
  

  override var contentSize: CGSize {
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }

}
