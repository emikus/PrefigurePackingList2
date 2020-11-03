//
//  SharedMethods.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import Foundation
import CoreData


class DataFacade: ObservableObject, Identifiable {
    let managedContext = PersistenceController.shared.container.viewContext
    let bagContentSetFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BagContentSet")
    let activityFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Activity")
    
    public func getItemsInBagWeight(itemsInBag: [Item]) -> Int {
        var itemsWeight = 0
        for item in itemsInBag {
            itemsWeight += Int(item.weight)
        }
        
        return itemsWeight
    }
    
    public func getItemsInBagVolume(itemsInBag: [Item]) -> Int {
        var itemsVolume = 0
        for item in itemsInBag {
            itemsVolume += Int(item.volume)
        }
        
        return itemsVolume
    }
    
    public func getActivityIsSelected(activity: Activity) -> Bool {
        return activity.isSelected
    }
    
    public func getBagContentSetModulesAndTheirItems (bagContentSetName: String) -> [String: [String:Item]] {
        var modulesAndTheirItems: [String: [String:Item]] = [:]
        
        do {
            let bagContentSets = try managedContext.fetch(bagContentSetFetchRequest)
            
            let bagContentSetsArray = bagContentSets as! [BagContentSet]
            let bagContentSetArray = bagContentSetsArray.filter({$0.name == bagContentSetName})[0]
            
            print(bagContentSetArray)
            for moduleSet in bagContentSetArray.modulesSetArray {
                var modulesWithItems: [String:Item] = [:]
                
                for module in moduleSet.modulesArray {
                    modulesWithItems[module.symbol!] = module.item
                }
                
                modulesAndTheirItems[moduleSet.name!] = modulesWithItems
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(modulesAndTheirItems)
        return modulesAndTheirItems
    }
    
    
    
    public func addNewItemToActivities(newItem: Item, itemActivities: [Activity]) {
        do {
            let activities = try managedContext.fetch(activityFetchRequest)
            
            let activitiesArray = activities as! [Activity]
            
            for activity in activitiesArray {
                if itemActivities.contains(activity) {
                    activity.addToItem(newItem)
                }
            }
            
            try? managedContext.save()

//            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    public func updateItemActivities(item: Item, itemActivities: [Activity]) {
        do {
            let activities = try managedContext.fetch(activityFetchRequest)
            
            let activitiesArray = activities as! [Activity]
            
            for activity in activitiesArray {
                if itemActivities.contains(activity) {
                    if !activity.itemArray.contains(item) {
                    activity.addToItem(item)
                    }
                } else {
                    activity.removeFromItem(item)
                }
            }
            
            try? managedContext.save()

//            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    public func checkIfItemActivitiesAreSelected(item: Item) -> Bool {
        var selectedActivitiesContainItem:Bool = false
        do {
            let activities = try managedContext.fetch(activityFetchRequest)
            
            let activitiesArray = activities as! [Activity]
            
            selectedActivitiesContainItem = activitiesArray.filter({$0.isSelected==true}).contains{ $0.item!.contains(item)}

            

//            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return selectedActivitiesContainItem
    }
    
    public func removeItem(item: Item) {
        managedContext.delete(item)
        try? managedContext.save()
    }
    
    public func removeActivity(activity: Activity) {
        managedContext.delete(activity)
        try? managedContext.save()
    }
    
    public func pinUnpinItem(item: Item) {
        item.isPinned.toggle()
        try? managedContext.save()
    }
    
    public func pinUnpinActivity(activity: Activity) {
        activity.isPinned.toggle()
        try? managedContext.save()
    }
    
    public func selectDeselectActivity(activity: Activity) {
        
        activity.isSelected.toggle()
        if activity.isSelected == true {
            for item in activity.itemArray {
                item.isInBag = true
            }
        } else {
            do {
                let activities = try managedContext.fetch(activityFetchRequest)
                
                let activitiesArray = activities as! [Activity]
                
                for item in activity.itemArray {
                    
                    let selectedActivitiesContainItem = activitiesArray.filter({$0.isSelected==true}).contains{ $0.item!.contains(item)}
                    
                    if !selectedActivitiesContainItem {
                        item.isInBag = false
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        }
        try? managedContext.save()
    }
    
    
}

var dataFacade = DataFacade()
