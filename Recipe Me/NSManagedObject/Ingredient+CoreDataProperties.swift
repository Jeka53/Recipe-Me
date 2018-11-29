//
//  Ingredient+CoreDataProperties.swift
//  Recipe Me
//
//  Created by Jora on 10/24/18.
//  Copyright © 2018 Jora. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var details: String?
    @NSManaged public var isPresent: Bool
    @NSManaged public var recipe: Recipe?

}
