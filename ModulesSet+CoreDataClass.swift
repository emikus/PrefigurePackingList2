//
//  ModulesSet+CoreDataClass.swift
//  PPL
//
//  Created by Macbook Pro on 20/10/2020.
//
//

import Foundation
import CoreData

@objc(ModulesSet)
public class ModulesSet: NSManagedObject {
    
}

extension ModulesSet {
    public var modulesArray: [Module] {
        let set = module as? Set<Module> ?? []
        
        return set.sorted {
            $0.symbol! < $1.symbol!
        }
    }
}

