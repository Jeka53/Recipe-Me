//
//  Recipe+CoreDataProperties.swift
//  Recipe Me
//
//  Created by Jora on 10/18/18.
//  Copyright © 2018 Jora. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var title: String?
    @NSManaged public var time: Int16
    @NSManaged public var details: String?
    @NSManaged public var image: NSData?
    @NSManaged public var category: Category?
    @NSManaged public var ingridients: NSOrderedSet?
    @NSManaged public var steps: NSOrderedSet?

}

// MARK: Generated accessors for ingridients
extension Recipe {

    @objc(insertObject:inIngridientsAtIndex:)
    @NSManaged public func insertIntoIngridients(_ value: Ingridient, at idx: Int)

    @objc(removeObjectFromIngridientsAtIndex:)
    @NSManaged public func removeFromIngridients(at idx: Int)

    @objc(insertIngridients:atIndexes:)
    @NSManaged public func insertIntoIngridients(_ values: [Ingridient], at indexes: NSIndexSet)

    @objc(removeIngridientsAtIndexes:)
    @NSManaged public func removeFromIngridients(at indexes: NSIndexSet)

    @objc(replaceObjectInIngridientsAtIndex:withObject:)
    @NSManaged public func replaceIngridients(at idx: Int, with value: Ingridient)

    @objc(replaceIngridientsAtIndexes:withIngridients:)
    @NSManaged public func replaceIngridients(at indexes: NSIndexSet, with values: [Ingridient])

    @objc(addIngridientsObject:)
    @NSManaged public func addToIngridients(_ value: Ingridient)

    @objc(removeIngridientsObject:)
    @NSManaged public func removeFromIngridients(_ value: Ingridient)

    @objc(addIngridients:)
    @NSManaged public func addToIngridients(_ values: NSOrderedSet)

    @objc(removeIngridients:)
    @NSManaged public func removeFromIngridients(_ values: NSOrderedSet)

}

// MARK: Generated accessors for steps
extension Recipe {

    @objc(insertObject:inStepsAtIndex:)
    @NSManaged public func insertIntoSteps(_ value: Step, at idx: Int)

    @objc(removeObjectFromStepsAtIndex:)
    @NSManaged public func removeFromSteps(at idx: Int)

    @objc(insertSteps:atIndexes:)
    @NSManaged public func insertIntoSteps(_ values: [Step], at indexes: NSIndexSet)

    @objc(removeStepsAtIndexes:)
    @NSManaged public func removeFromSteps(at indexes: NSIndexSet)

    @objc(replaceObjectInStepsAtIndex:withObject:)
    @NSManaged public func replaceSteps(at idx: Int, with value: Step)

    @objc(replaceStepsAtIndexes:withSteps:)
    @NSManaged public func replaceSteps(at indexes: NSIndexSet, with values: [Step])

    @objc(addStepsObject:)
    @NSManaged public func addToSteps(_ value: Step)

    @objc(removeStepsObject:)
    @NSManaged public func removeFromSteps(_ value: Step)

    @objc(addSteps:)
    @NSManaged public func addToSteps(_ values: NSOrderedSet)

    @objc(removeSteps:)
    @NSManaged public func removeFromSteps(_ values: NSOrderedSet)

}
