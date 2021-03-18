//
//  Activity+CoreDataClass.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//
//

import Foundation
import CoreData

@objc(Activity)
public class Activity: NSManagedObject {

}


extension Activity {
    
    public var wrappedName:String {
        return name ?? ""
    }
    
    public var wrappedCategory:String {
        return category ?? ""
    }
    
    public var wrappedSymbol:String {
        return symbol ?? ""
    }
    
    public var wrappedDuration:Int16 {
        return duration
    }
    
    public var itemArray: [Item] {
        let set = item as? Set<Item> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var tagArray: [Tag] {
        let set = tag as? Set<Tag> ?? []
        
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    

    
    public var durationInHoursAndMinutes: String {
        
        let hours = self.duration / 60 < 10 ? "0" + String(self.duration / 60) : String(self.duration / 60)
        let minutes = self.duration % 60 < 10 ? "0" + String(self.duration % 60) : String(self.duration % 60)

        return hours + ":" + minutes
    }

}
