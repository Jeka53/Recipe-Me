//
//  AppDelegate.swift
//  Recipe Me
//
//  Created by Jora on 10/17/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    importJSONdataIfNeeded()
    
    guard let _ = window?.rootViewController as? TabBarController else {
      return true
    }
    
    TabBarController.managedContext = persistentContainer.viewContext
    
    return true
  }
  
  private func importJSONdataIfNeeded() {
    
    let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
    let count = try! persistentContainer.viewContext.count(for: fetchRequest)
    
    guard count == 0 else { return }
    
    // populate Core Data model with sample Recipe from .json file
    
    let jsonURL = Bundle.main.url(forResource: "seed", withExtension: "json")
    let jsonData = try! Data(contentsOf: jsonURL!)
    
    let jsonContent = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
    let recipeDict = jsonContent["recipe"] as! [String: Any]
    
    // parse Category
    let categoryDict = recipeDict["category"] as! [String: Any]
    let categoryName = categoryDict["name"] as! String
    let categoryCount = categoryDict["numberOfRecipes"] as! Int16
    
    // parse recipe attributes
    let title = recipeDict["title"] as! String
    let time = recipeDict["time"] as! Int16
    let details = recipeDict["details"] as! String
    
    // parse Title Image
    let imageName = recipeDict["image"] as! String
    let image = UIImage(named: imageName)!
    let imageData = image.pngData()! as NSData
    
    let category = Category(context: persistentContainer.viewContext)
    category.name = categoryName
    category.numberOfRecipes = categoryCount
    
    let recipe = Recipe(context: persistentContainer.viewContext)
    recipe.category = category
    recipe.title = title
    recipe.time = time
    recipe.details = details
    recipe.image = imageData
    
    let ingridientsArray = recipeDict["ingridients"] as! [[String: Any]]
    
    for ingridientDict in ingridientsArray {
      let ingridient = Ingridient(context: persistentContainer.viewContext)
      ingridient.details = ingridientDict["details"] as? String
      ingridient.isPresent = ingridientDict["isPresent"] as! Bool
      recipe.addToIngridients(ingridient)
    }
    
    let stepsArray = recipeDict["steps"] as! [[String: String]]
    
    for stringDict in stepsArray {
      let step = Step(context: persistentContainer.viewContext)
      step.details = stringDict["details"]
      let imageString = stringDict["photo"]
      let image = UIImage(named: imageString!)!
      let imageData = image.pngData()! as NSData
      step.image = imageData
      recipe.addToSteps(step)
    }
    
    category.addToRecipes(recipe)
    
    saveContext()
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "Recipe_Me")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

}

