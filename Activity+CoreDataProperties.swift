//
//  Activity+CoreDataProperties.swift
//  PPL
//
//  Created by Macbook Pro on 30/10/2020.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var category: String?
    @NSManaged public var duration: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var isSelected: Bool
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var isPinned: Bool
    @NSManaged public var item: NSSet?

}

// MARK: Generated accessors for item
extension Activity {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

extension Activity : Identifiable {

}
