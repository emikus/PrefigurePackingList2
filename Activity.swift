//
//  Activity.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import Foundation


class Activity: Identifiable, Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    var name: String
    var symbol: String
    var duration: Int
    var items: [Item]
    var category: ActivityCategory
    
    
    var itemsVolume: Int {
        var itemsVolume = 0
        
        for item in items {
            itemsVolume += item.volume
        }
        
        return itemsVolume
    }
    
    
    var itemsWeight: Int {
        var itemsWeight = 0
        
        for item in items {
            print(item.weight)
            itemsWeight += item.weight
        }
        
        return itemsWeight
    }
    
    init(name: String, symbol: String, duration: Int, items: [Item], category: ActivityCategory) {
        self.name = name
        self.symbol = symbol
        self.duration = duration
        self.items = items
        self.category = category
    }
}


class Activities: ObservableObject {
    @Published var activities: [Activity]
    @Published var selectedActivities: [Activity]
    var suggestedActivities: [Activity]
    
    var selectedActivitiesDuration: Int {
        var selectedActivitiesDuration = 0
        for selectedActivity in selectedActivities {
            selectedActivitiesDuration += selectedActivity.duration
        }
        
        return selectedActivitiesDuration
    }

    init() {
        self.activities = []
        self.suggestedActivities = []
        self.selectedActivities = []
        
        
            self.activities = sampleActivites
            
            self.suggestedActivities.append(sampleActivites[0])
            self.suggestedActivities.append(sampleActivites[5])
    }
}


//let sampleItems = Items(fillWithSampleData: true)



