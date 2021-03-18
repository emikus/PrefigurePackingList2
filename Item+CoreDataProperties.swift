//
//  Item+CoreDataProperties.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 16/03/2021.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var batteryConsumption: Int16
    @NSManaged public var cost: Int16
    @NSManaged public var electric: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var isInBag: Bool
    @NSManaged public var isInModuleSlot: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var itemCategory: String?
    @NSManaged public var moduleSymbol: String?
    @NSManaged public var name: String?
    @NSManaged public var refillable: Bool
    @NSManaged public var symbol: String?
    @NSManaged public var ultraviolet: Bool
    @NSManaged public var volume: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var activity: NSSet?
    @NSManaged public var tag: NSSet?

}

// MARK: Generated accessors for activity
extension Item {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}

// MARK: Generated accessors for tag
extension Item {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}

extension Item : Identifiable {

}
