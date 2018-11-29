//
//  ImageWithDescriptionUploader.swift
//  ImageWithDescriptionUploader
//
//  Created by Jora on 11/9/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class ImageWithDescriptionUploader: NSObject {
  
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView.delegate = self
      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(resignTextView))
      tapRecognizer.cancelsTouchesInView = false
      scrollView.addGestureRecognizer(tapRecognizer)
      scrollView.panGestureRecognizer.addTarget(self, action: #selector(resignTextView))
    }
  }
  
  @IBOutlet weak var collectionView: CreateStepCollectionView! {
    didSet {
      collectionView.dataForSelectedIndexPath = { [weak self] image, text in
        self?.imageView.image = image
        self?.textView.text = text
      }
    }
  }
  
  @IBOutlet weak var imageView: UIImageView! {
    didSet {
      imagePickerController = UIImagePickerController()
      imagePickerController?.delegate = self
      imagePickerController?.allowsEditing = true
      let tapGesture = UITapGestureRecognizer()
      tapGesture.addTarget(self, action: #selector(addImage))
      imageView.isUserInteractionEnabled = true
      imageView.addGestureRecognizer(tapGesture)
    }
  }
  
  @IBOutlet weak var textView: UITextView! {
    didSet {
      textView.delegate = self
    }
  }
  
  let keyboardHeightPortrait = 216
  
  var imagePickerController: UIImagePickerController?
  
  @objc func resignTextView() {
    // resign textView as first responder on tap inside scroll view
    textView.resignFirstResponder()
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  @objc func addImage() {
    guard let imagePickerController = imagePickerController else { return }
    
    weak var nearestAncestorVC = getTopViewController()
    
    let alert = UIAlertController(title: "Choose action:", message: nil, preferredStyle: .actionSheet)
    let fromCameraAction = UIAlertAction(title: "Take picture", style: .default) { _ in
      imagePickerController.sourceType = .camera
      nearestAncestorVC?.present(imagePickerController, animated: true, completion: nil)
    }
    let fromLibraryAction = UIAlertAction(title: "Pick existing photo", style: .default) { _ in
      imagePickerController.sourceType = .photoLibrary
      
      nearestAncestorVC?.present(imagePickerController, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(fromCameraAction)
    alert.addAction(fromLibraryAction)
    alert.addAction(cancelAction)
    UIView.animate(withDuration: 0.2) {
      self.resignTextView()
    }
    nearestAncestorVC?.present(alert, animated: true, completion: nil)
  }
  
  // FIXME: Refactor ImageWithDescriptionUploader to be a viewController
  func getTopViewController() -> UIViewController {
    var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
    while (topViewController.presentedViewController != nil) {
      topViewController = topViewController.presentedViewController!
    }
    return topViewController
  }
  
  func validateStep() {
      if collectionView.indexPathsForSelectedItems?.first?.row == collectionView.steps.count - 1 {
        collectionView.steps.append(RecipeStep(image: UIImage(named: "cameraIcon"), text: ""))
        collectionView.selectedIndexPath = IndexPath(row: collectionView.steps.count - 2, section: 0)
        collectionView.reloadData()
        let indexPath = IndexPath(row: self.collectionView.steps.count - 1 , section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
      }
  }
  
}

// MARK: - UITextViewDelegate
extension ImageWithDescriptionUploader: UITextViewDelegate {
  
  // make textView first responder with a proper animation
  func textViewDidBeginEditing(_ textView: UITextView) {
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(keyboardHeightPortrait), right: 0)
    let rect = CGRect(x: 0, y: scrollView.bounds.height, width: scrollView.bounds.width, height: 1)
    scrollView.scrollRectToVisible(rect, animated: true)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
    collectionView.steps[indexPath.row].text = textView.text
    if textView.text.count > 1 {
      validateStep()
    }
  }
}

extension ImageWithDescriptionUploader: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate
extension ImageWithDescriptionUploader: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    imageView.image = image
    if let indexPath = collectionView.indexPathsForSelectedItems?.first {
      collectionView.steps[indexPath.row].image = image
      validateStep()
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
}
