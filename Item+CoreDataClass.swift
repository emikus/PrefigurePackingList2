//
//  Item+CoreDataClass.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//
//

import Foundation
import CoreData

@objc(Item)
final public class Item: NSManagedObject {

}

extension Item {
    public static let typeIdentifier = "ppl.item"
    
    public var wrappedName:String {
        return name ?? "Unknown name"
    }
    
    public var wrappedSymbol:String {
        return symbol ?? "Unknown symbol"
    }
    public var wrappedModuleSymbol:String {
        return moduleSymbol ?? "Unknown symbol"
    }
    
    public var wrappedWeight:Int {
        return Int(weight)
    }
    
    public var tagArray: [Tag] {
        let set = tag as? Set<Tag> ?? []
        
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    
    
}

extension Item: NSItemProviderReading {
    
    public static var readableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    public static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Item {
        let components = String(data: data, encoding: .utf8)!.split(separator: ",").map(String.init)
        let item = Item()

        item.batteryConsumption = Int16(components[1])!
        item.cost = Int16(components[2])!
        item.id = UUID(uuidString: components[3])!
        item.isInBag = components[4].trimmingCharacters(in: .whitespaces) == "false" ? false : true
        item.isInModuleSlot = components[5].trimmingCharacters(in: .whitespaces) == "false" ? false : true
        item.itemCategory = components[6].trimmingCharacters(in: .whitespaces)
        item.moduleSymbol = components[7].trimmingCharacters(in: .whitespaces)
        item.name = components[8].trimmingCharacters(in: .whitespaces)
        item.symbol = components[9].trimmingCharacters(in: .whitespaces)
        item.volume = Int16(components[10])!
        item.weight = Int16(components[11])!
//        item.origin = []
print("JDJKLJKLJKLJKLJKLJKL")
        item.id = UUID(uuidString: components[0])!
        return item
    }
}

extension Item: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] = [typeIdentifier]

    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        completionHandler("\(String(describing: id)), \(String(describing: name)),\(weight), \(volume), \(cost), \(batteryConsumption), \(symbol ?? ""), \(String(describing: itemCategory)), \(moduleSymbol ?? ""), \(isInModuleSlot)".data(using: .utf8), nil) // very terrible encoding and decoding 🙃
        let p = Progress(totalUnitCount: 1)
        p.completedUnitCount = 1
        print("fndjkfieowjiowjfiow")
        return p
    }
}
