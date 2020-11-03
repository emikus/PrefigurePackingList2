//
//  BagContentSet+CoreDataProperties.swift
//  PPL
//
//  Created by Macbook Pro on 20/10/2020.
//
//

import Foundation
import CoreData


extension BagContentSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BagContentSet> {
        return NSFetchRequest<BagContentSet>(entityName: "BagContentSet")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var item: NSSet?
    @NSManaged public var modulesSet: NSSet?

}

// MARK: Generated accessors for item
extension BagContentSet {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

// MARK: Generated accessors for modulesSet
extension BagContentSet {

    @objc(addModulesSetObject:)
    @NSManaged public func addToModulesSet(_ value: ModulesSet)

    @objc(removeModulesSetObject:)
    @NSManaged public func removeFromModulesSet(_ value: ModulesSet)

    @objc(addModulesSet:)
    @NSManaged public func addToModulesSet(_ values: NSSet)

    @objc(removeModulesSet:)
    @NSManaged public func removeFromModulesSet(_ values: NSSet)

}

extension BagContentSet : Identifiable {

}
