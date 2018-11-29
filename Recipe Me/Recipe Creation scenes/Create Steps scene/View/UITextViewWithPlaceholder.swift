//
//  UITextViewWithPlaceholder.swift
//  UITextViewWithPlaceholder
//
//  Created by Jora on 11/1/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

@IBDesignable
class UITextViewWithPlaceholder: UITextView {
  
  // MARK: - Inspectable properties
  // UITextView properties
  @IBInspectable var borderColor: UIColor? {
    get {
      guard let color = layer.borderColor else { return nil }
      return UIColor(cgColor: color)
    }
    set {
      guard let newColor = newValue else { return }
      layer.borderColor = newColor.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  // Placeholder properties
  @IBInspectable var withPlaceholder: Bool = true {
    didSet {
      guard placeholder == nil else { return }
      placeholder = UILabel()
    }
  }
  
  @IBInspectable var placeholderText: String?
  @IBInspectable var placeholderTextColor: UIColor?
  var placeholderFont: UIFont?
  
  // MARK: - Overrides
  override var font: UIFont? {
    didSet {
      placeholderFont = font
    }
  }
  
  // properties
  var placeholder: UILabel?
  let defaultPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    
    guard placeholder != nil else { return }
    
    // placeholder appearance
    placeholder!.text = placeholderText
    placeholder!.textColor = defaultPlaceholderColor
    placeholder!.font = placeholderFont
    placeholder!.numberOfLines = 0
    placeholder!.preferredMaxLayoutWidth = self.bounds.width - 8
    
  
    NotificationCenter.default.addObserver(self, selector: #selector(showPlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    
    // constraints
    self.addSubview(placeholder!)
    placeholder!.translatesAutoresizingMaskIntoConstraints = false
    placeholder!.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    placeholder!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8).isActive = true
    placeholder!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
    placeholder!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4).isActive = true
  }
  
  override var text: String! {
    didSet {
      guard placeholder != nil, withPlaceholder != false else {
        return
      }
      showPlaceholder()
    }
  }
  
  // MARK: - Methods
  @objc func showPlaceholder() {
    placeholder!.isHidden = self.text.count > 0
  }
}
