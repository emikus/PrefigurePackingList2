//
//  Item+CoreDataProperties.swift
//  PPL
//
//  Created by Macbook Pro on 19/10/2020.
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
    @NSManaged public var id: UUID?
    @NSManaged public var isInBag: Bool
    @NSManaged public var isInModuleSlot: Bool
    @NSManaged public var itemCategory: String?
    @NSManaged public var moduleSymbol: String?
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var volume: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var isPinned: Bool
    @NSManaged public var origin: NSSet?

}

// MARK: Generated accessors for origin
extension Item {

    @objc(addOriginObject:)
    @NSManaged public func addToOrigin(_ value: Activity)

    @objc(removeOriginObject:)
    @NSManaged public func removeFromOrigin(_ value: Activity)

    @objc(addOrigin:)
    @NSManaged public func addToOrigin(_ values: NSSet)

    @objc(removeOrigin:)
    @NSManaged public func removeFromOrigin(_ values: NSSet)

}

extension Item : Identifiable {

}
