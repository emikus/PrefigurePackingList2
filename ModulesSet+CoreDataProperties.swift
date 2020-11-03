//
//  ModulesSet+CoreDataProperties.swift
//  PPL
//
//  Created by Macbook Pro on 20/10/2020.
//
//

import Foundation
import CoreData


extension ModulesSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModulesSet> {
        return NSFetchRequest<ModulesSet>(entityName: "ModulesSet")
    }

    @NSManaged public var name: String?
    @NSManaged public var module: NSSet?

}

// MARK: Generated accessors for module
extension ModulesSet {

    @objc(addModuleObject:)
    @NSManaged public func addToModule(_ value: Module)

    @objc(removeModuleObject:)
    @NSManaged public func removeFromModule(_ value: Module)

    @objc(addModule:)
    @NSManaged public func addToModule(_ values: NSSet)

    @objc(removeModule:)
    @NSManaged public func removeFromModule(_ values: NSSet)

}

extension ModulesSet : Identifiable {

}
