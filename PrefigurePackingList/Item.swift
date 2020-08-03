//
//  Item.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import Foundation


class Item: Identifiable, Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var name = "Anonymous"
    var weight: Int
    var volume: Int
    
    var volumeWithUnit: Measurement<UnitVolume> {
        
        get {
            let itemVolume = Measurement(value: Double(self.volume), unit: UnitVolume.cubicCentimeters)
            return itemVolume
        }
    }
    
    
    
    var activities: [Int]
    
    init(name: String, weight: Int, volume: Int, activities: [Int]) {
        self.name = name
        self.weight = weight
        self.volume = volume
        self.activities = activities
    }
    
}

class Items: ObservableObject, Identifiable {
    @Published var items = [Item]()
    @Published var itemsInBag = [Item]()
    var itemsActivitySymbols: [UUID:[UUID:String]] = [:]
    
    var itemsInBagWeight:Int {
        var itemsWeight = 0
        for item in itemsInBag {
            itemsWeight += item.weight
        }
        
        return itemsWeight
    }
    
    var itemsInBagVolume:Int {
        var itemsVolume = 0
        for item in itemsInBag {
            itemsVolume += item.volume
        }
        
        return itemsVolume
    }


    init(fillWithSampleData: Bool) {
        
        if fillWithSampleData {
            items = sampleItems
        }
        
        for item in items {
            let activitiesContainingItem: [Activity] = sampleActivites.filter {$0.items.contains(item)}

            self.itemsActivitySymbols[item.id] = activitiesContainingItem.reduce(into: [UUID: String]()) { $0[$1.id] = $1.symbol }
        }
    }
}


