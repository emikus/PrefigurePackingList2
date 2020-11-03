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
        return name ?? "Unknown name"
    }
    
    public var wrappedCategory:String {
        return category ?? "Unknown category"
    }
    
    public var wrappedSymbol:String {
        return symbol ?? "Unknown symbol"
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
    

    
    public var durationInHoursAndMinutes: String {
        
        let hours = self.duration / 60 < 10 ? "0" + String(self.duration / 60) : String(self.duration / 60)
        let minutes = self.duration % 60 < 10 ? "0" + String(self.duration % 60) : String(self.duration % 60)

        return hours + ":" + minutes
    }

}
