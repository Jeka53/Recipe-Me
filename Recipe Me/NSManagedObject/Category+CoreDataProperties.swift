//
//  Category+CoreDataProperties.swift
//  Recipe Me
//
//  Created by Jora on 10/18/18.
//  Copyright © 2018 Jora. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var numberOfRecipes: Int16
    @NSManaged public var name: String?
    @NSManaged public var recipes: NSOrderedSet?

}

// MARK: Generated accessors for recipes
extension Category {

    @objc(insertObject:inRecipesAtIndex:)
    @NSManaged public func insertIntoRecipes(_ value: Recipe, at idx: Int)

    @objc(removeObjectFromRecipesAtIndex:)
    @NSManaged public func removeFromRecipes(at idx: Int)

    @objc(insertRecipes:atIndexes:)
    @NSManaged public func insertIntoRecipes(_ values: [Recipe], at indexes: NSIndexSet)

    @objc(removeRecipesAtIndexes:)
    @NSManaged public func removeFromRecipes(at indexes: NSIndexSet)

    @objc(replaceObjectInRecipesAtIndex:withObject:)
    @NSManaged public func replaceRecipes(at idx: Int, with value: Recipe)

    @objc(replaceRecipesAtIndexes:withRecipes:)
    @NSManaged public func replaceRecipes(at indexes: NSIndexSet, with values: [Recipe])

    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: Recipe)

    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: Recipe)

    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSOrderedSet)

    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSOrderedSet)

}
