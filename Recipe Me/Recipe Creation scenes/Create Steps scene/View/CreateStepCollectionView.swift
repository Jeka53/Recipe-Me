//
//  CreateStepCollectionView.swift
//  ImageWithDescriptionUploader
//
//  Created by Jora on 11/9/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

struct RecipeStep {
  var image: UIImage?
  var text: String?
}

class CreateStepCollectionView: UICollectionView {

  var steps: [RecipeStep] = [RecipeStep(image: UIImage(named: "cameraIcon"), text: "")]
  let cellIdentifier = "ImageCell"
  
  // Callbacks
  var dataForSelectedIndexPath: ((_ image: UIImage? , _ text: String) -> Void)?
  var collectionWasReloaded: ((Int) -> Void)?
  
  var selectedIndexPath: IndexPath?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    
    delegate = self
    dataSource = self
    
  }
  
  override func reloadData() {
    super.reloadData()
    
    // Callback
    collectionWasReloaded?(steps.count)
    
    // CollectionView selection logic after reload data
    guard let selectedIndexPath = selectedIndexPath, steps.count != 0 else { return }
    
    selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
  }
}


// MARK: - UICollectionViewDataSource
extension CreateStepCollectionView: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return steps.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell
    cell.numberLabel.text = String(indexPath.row + 1)
    let labelSize = cell.bounds.height / 2
    cell.numberLabel.font = cell.numberLabel.font.withSize(labelSize)
    cell.layer.borderWidth = 1
    cell.layer.borderColor = UIColor.lightGray.cgColor
    if steps.count == 1 {
      cell.isSelected = true
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateStepCollectionView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    flowLayout.minimumLineSpacing = 8
    return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
  }
}

// MARK: - UICollectionViewDelegate
extension CreateStepCollectionView : UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let text = steps[indexPath.row].text
    let image = steps[indexPath.row].image
    dataForSelectedIndexPath?(image, text!)
    
  }
  
}
