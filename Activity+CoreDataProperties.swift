//
//  Activity+CoreDataProperties.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 18/03/2021.
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
    @NSManaged public var isPinned: Bool
    @NSManaged public var isSelected: Bool
    @NSManaged public var name: String?
    @NSManaged public var symbol: String?
    @NSManaged public var item: NSSet?
    @NSManaged public var tag: NSSet?

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

// MARK: Generated accessors for tag
extension Activity {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: Tag)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: Tag)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}

extension Activity : Identifiable {

}
