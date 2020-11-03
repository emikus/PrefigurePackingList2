//
//  Module+CoreDataProperties.swift
//  PPL
//
//  Created by Macbook Pro on 20/10/2020.
//
//

import Foundation
import CoreData


extension Module {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Module> {
        return NSFetchRequest<Module>(entityName: "Module")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var item: Item?

}

extension Module : Identifiable {

}
