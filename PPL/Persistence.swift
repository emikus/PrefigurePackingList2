//
//  Persistence.swift
//  PPL
//
//  Created by Macbook Pro on 08/10/2020.
//

import CoreData


//let a:[Item] 


struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
//        for i in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.name = "Dupa"
//            newItem.itemCategory = ((i%2) != 0) ? "food" : "clothes"
//        }
        for i in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.name = "Testowy item"
            newItem.cost = 34
            newItem.weight = 456
            newItem.volume = 531
            newItem.symbol = ":)"
            newItem.itemCategory = ((i%2) != 0) ? "food" : "clothes"
            newItem.moduleSymbol = "🚢"
        }
        for i in 0..<5 {
            let newActivity = Activity(context: viewContext)
            newActivity.name = "Activity " + String(i)
            newActivity.duration = Int16(34 + i)
            newActivity.symbol = "456"
            newActivity.category = ((i%2) != 0) ? "general" : "specific"
            newActivity.symbol = ":)"
        }
        
        for i in 0..<5 {
            let newActivity = Tag(context: viewContext)
            newActivity.name = "#tag " + String(i)
        }
        
        // test bag content set
        let newBagContentSet = BagContentSet(context: viewContext)
        newBagContentSet.date = Date()
        newBagContentSet.name = "set testowy"
        // test bag content set END
        
        
        // test module
        let newItem = Item(context: viewContext)
        newItem.name = "Testowy item"
        newItem.cost = 34
        newItem.weight = 456
        newItem.volume = 531
        newItem.symbol = ":)"
        newItem.itemCategory = "clothes"
        newItem.moduleSymbol = "🚢"
        
        
        let newModule = Module(context: viewContext)
        newModule.item = newItem
        // test module END
        
        for i in 0..<15 {
            let newTag = Tag(context: viewContext)
            newTag.name = "#testowyTag" + String(i)
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PPL")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
