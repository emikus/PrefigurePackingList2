//
//  Activity.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import Foundation


class Activity: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    @Published var name: String
    @Published var symbol: String
    @Published var duration: Int
    @Published var items: [Item]
    @Published var category: ActivityCategory
    
    
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


class Activities: ObservableObject, Identifiable {
    @Published var activities: [Activity]
    @Published var selectedActivities: [Activity]
    @Published var activitiesPinned: [Activity]
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
        self.activitiesPinned = []
        
        
            self.activities = sampleActivites
            
//            self.suggestedActivities.append(sampleActivites[0])
//            self.activities.remove(at: 0)
//            self.suggestedActivities.append(sampleActivites[5])
//            self.activities.remove(at: 4)
    }
}


//let sampleItems = Items(fillWithSampleData: true)



