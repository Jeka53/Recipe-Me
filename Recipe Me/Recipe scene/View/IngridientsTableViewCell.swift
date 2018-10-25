//
//  IngridientsTableViewCell.swift
//  Recipe Me
//
//  Created by Jora on 10/24/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class IngridientsTableViewCell: UITableViewCell {
  
  var tableView: AutoHeightTableView!
  var ingridients: [Ingridient]!
  
  // will be never called
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupTableView()
  }
  
    
  func setupTableView() {
    tableView = AutoHeightTableView(frame: CGRect.zero, style: .plain)
    
    contentView.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.bounces = false
    tableView.isScrollEnabled = false
    
    
    // constraints
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    tableView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}

// MARK: - UITableViewDataSource
extension IngridientsTableViewCell: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard ingridients != nil else { return 0 }
    
    return ingridients.count 
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // text appearance
    if ingridients[indexPath.row].isPresent {
      let attributedString = NSAttributedString(string: ingridients[indexPath.row].details!,
                                                attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
      cell.textLabel?.attributedText = attributedString
      cell.textLabel?.textColor = .gray
    } else {
      cell.textLabel?.attributedText = nil
      cell.textLabel?.text = ingridients[indexPath.row].details
      cell.textLabel?.textColor = UIColor(white: 0.15, alpha: 1)
    }
    cell.textLabel?.font = UIFont.italicSystemFont(ofSize: 17)
    
    // cell appearance
    cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Ingridients:"
  }
}



// MARK: - UITableViewDelegate
extension IngridientsTableViewCell: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath)
    
    if ingridients[indexPath.row].isPresent == false {
      let attributedString = NSAttributedString(string: ingridients[indexPath.row].details!,
                                                attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
      cell?.textLabel?.attributedText = attributedString
      cell?.textLabel?.textColor = .gray
      ingridients[indexPath.row].isPresent = true
    } else if ingridients[indexPath.row].isPresent {
      cell?.textLabel?.attributedText = nil
      cell?.textLabel?.text = ingridients[indexPath.row].details
      cell?.textLabel?.textColor = UIColor(white: 0.15, alpha: 1)
      ingridients[indexPath.row].isPresent = false
    }
  }
}
