//
//  TabBarController.swift
//  Recipe Me
//
//  Created by Jora on 10/17/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController {
  
  // will use singleton instead of dependency injection for simplicity
  static var managedContext: NSManagedObjectContext!
  
}
