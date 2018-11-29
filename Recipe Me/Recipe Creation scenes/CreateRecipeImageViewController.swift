//
//  CreateRecipeImageViewController.swift
//  Recipe Me
//
//  Created by Jora on 11/16/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class CreateRecipeImageViewController: UIViewController {
  
  @IBAction func createRecipe(_ sender: UIBarButtonItem) {
    navigationController?.dismiss(animated: true, completion: nil)
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
  
  weak var managedContext = TabBarController.managedContext
  var imagePickerController: UIImagePickerController!
  var recipeTitle: String!
  var recipe: Recipe!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.async {
      self.fetchRecipeImage()
    }
  }
  
  deinit {
    print("CreateRecipeImageViewController was deinitialied")
  }
  
  func fetchRecipeImage() {
    let fetchRequest: NSFetchRequest = Recipe.fetchRequest()
    let recipeByNamePredicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.title), recipeTitle)
    fetchRequest.predicate = recipeByNamePredicate
    
    do {
      let recipes = try managedContext?.fetch(fetchRequest)
      guard let recipe = recipes?.first else {return}
      self.recipe = recipe
      guard let nsImage = recipe.image else {return}
      let imageData = nsImage as Data?
      if let imageData = imageData {
        let image = UIImage(data: imageData)
        imageView.image = image
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @objc func addImage() {
    guard let imagePickerController = imagePickerController else { return }
    
    let alert = UIAlertController(title: "Choose action:", message: nil, preferredStyle: .actionSheet)
    let fromCameraAction = UIAlertAction(title: "Take picture", style: .default) { _ in
      imagePickerController.sourceType = .camera
      self.present(imagePickerController, animated: true, completion: nil)
    }
    let fromLibraryAction = UIAlertAction(title: "Pick existing photo", style: .default) { _ in
      imagePickerController.sourceType = .photoLibrary
      
      self.present(imagePickerController, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(fromCameraAction)
    alert.addAction(fromLibraryAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension CreateRecipeImageViewController: UINavigationControllerDelegate {}

extension CreateRecipeImageViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    imageView.image = image
    
    let imageData = image.pngData() as NSData?
    recipe.image = imageData
    
    DispatchQueue.main.async {
      do {
        try self.managedContext?.save()
      } catch {
        print(error.localizedDescription)
      }
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
}
