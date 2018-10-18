//
//  Ingridient+CoreDataProperties.swift
//  Recipe Me
//
//  Created by Jora on 10/18/18.
//  Copyright © 2018 Jora. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingridient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingridient> {
        return NSFetchRequest<Ingridient>(entityName: "Ingridient")
    }

    @NSManaged public var details: String?
    @NSManaged public var recipe: Recipe?

}
