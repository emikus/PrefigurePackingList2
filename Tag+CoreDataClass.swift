//
//  Tag+CoreDataClass.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 10/03/2021.
//
//

import Foundation
import CoreData
import SwiftUI

@objc(Tag)
public class Tag: NSManagedObject {

}

extension Tag {
    public var wrappedName:String {
        return name ?? "Unknown name"
    }
    
    public var wrappedIcon:String {
        return icon ?? "number"
    }
    
    public var itemArray: [Item] {
        let set = item as? Set<Item> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var activityArray: [Activity] {
        let set = activity as? Set<Activity> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var iconCategoryColor: Color {
        if name == nil || wrappedIcon == "number" {
            return Color.orange
        } else {
            
            let iconCategory = symbols.first(where: { $0.value.contains(wrappedIcon) })?.key
            return categoriesRainbowColors[iconCategory!]!
        }
    }
}
