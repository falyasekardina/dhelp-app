//
//  Intake+CoreDataProperties.swift
//  DhelpApp
//
//  Created by Reza Harris on 09/04/21.
//
//

import Foundation
import CoreData


extension Intake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Intake> {
        return NSFetchRequest<Intake>(entityName: "Intake")
    }

    @NSManaged public var calories: Int64
    @NSManaged public var carbs: Double
    @NSManaged public var createdat: Date?
    @NSManaged public var manualsize: String?
    @NSManaged public var mealtime: String?
    @NSManaged public var name: String?
    @NSManaged public var servingsize: Double
    @NSManaged public var sugar: Double

}

extension Intake : Identifiable {

}
