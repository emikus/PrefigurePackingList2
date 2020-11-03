//
//  BagContentSet+CoreDataClass.swift
//  PPL
//
//  Created by Macbook Pro on 20/10/2020.
//
//

import Foundation
import CoreData

@objc(BagContentSet)
public class BagContentSet: NSManagedObject {

}


extension BagContentSet {
    public var modulesSetArray: [ModulesSet] {
        let set = modulesSet as? Set<ModulesSet> ?? []
        
        return set.sorted {
            $0.name! < $1.name!
        }
    }
}
