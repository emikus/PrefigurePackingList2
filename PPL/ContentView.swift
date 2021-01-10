//
//  ContentView.swift
//  PPL
//
//  Created by Macbook Pro on 08/10/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var modules = Modules()
    var dataFacade = DataFacade()
    
        @Environment(\.managedObjectContext) private var viewContext
    
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
            animation: .default)
        private var items: FetchedResults<Item>
    
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
            animation: .default)
        private var activities: FetchedResults<Activity>
    
        @State var isInBag:Bool = false
        @State var bag:[Item] = []
    
    var body: some View {
    GeometryReader { geo in
     TabView {
        VStack {
            Button(action: {
                items[Int.random(in: 0...items.count - 1)].name = "dupa"
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }) {
                Label("Rename Item", systemImage: "plus")
            }
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }

            Button(action: {items[0].isInBag.toggle()}) {
                Label("Add remove to items bag", systemImage: "plus")
            }

            Button(action: {bag.insert(items[0], at: 0)}) {
                Label("Add remove to items bag array", systemImage: "plus")
            }

        HStack {
            List {
                ForEach(items) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }
                .onDelete(perform: deleteItems)
            }


            List {
                ForEach(items.filter({$0.isInBag == true})) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }

            }

            List {
                ForEach(bag) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }
                .onDelete(perform: deleteItems)

            }
        }
            VStack {
                Button(action: {
                    let activity = Activity(context: viewContext)
                    activity.id = UUID()
                    activity.name = randomString(length: 3)
                    activity.duration = Int16(75)
                    activity.category = "food"

                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }) {
                    Label("Add activity", systemImage: "plus")
                }


            HStack {
                List {
                    ForEach(activities) { activity in
                        HStack {
                            Text("\(activity.name!), \(activity.duration)")
                            Text(String(activity.itemArray.count))
                            HStack {
                                ForEach(activity.itemArray, id: \.self) { item in
                                    Text(item.wrappedName)
                                }

                            }
                        }
                        .onTapGesture {
                            if (activity.itemArray.contains(items[0])) {
                             activity.addToItem(items[1])

                            } else {
                                activity.addToItem(items[0])
                            }

                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }
                    .onDelete(perform: deleteActivity)

                }



            }
            }
            
        }
             .tabItem {
                 Image(systemName: "plus")
                 Text("⭕️ Aim")
             }
         
         PlanView()
             .tabItem {
                 Image(systemName: "plus")
                 Text("🟥 Plan")
             }
         
         Text("Middle item")
             .tabItem {
                 Image(systemName: "plus")
                 .font(.largeTitle)
         }
         
         BagView()
             .tabItem {
                 Image(systemName: "plus")
                 Text("🗄 Pack")
         }
        
        
        
        
         
        VStack {
            Button(action: {
                items[Int.random(in: 0...items.count - 1)].name = "dupa"
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }) {
                Label("Rename Item", systemImage: "plus")
            }
            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }

            Button(action: {items[0].isInBag.toggle()}) {
                Label("Add remove to items bag", systemImage: "plus")
            }

            Button(action: {bag.insert(items[0], at: 0)}) {
                Label("Add remove to items bag array", systemImage: "plus")
            }

        HStack {
            List {
                ForEach(items) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }
                .onDelete(perform: deleteItems)
            }


            List {
                ForEach(items.filter({$0.isInBag == true})) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }

            }

            List {
                ForEach(bag) { item in
                    VStack {
                        Text("\(item.wrappedName), \(item.cost), \(item.id!)")
                        Text(item.isInBag ? "In bag" : "not in bag")
                    }
                }
                .onDelete(perform: deleteItems)

            }
        }
            VStack {
                Button(action: {
                    let activity = Activity(context: viewContext)
                    activity.id = UUID()
                    activity.name = randomString(length: 3)
                    activity.duration = Int16(75)
                    activity.category = "food"

                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }) {
                    Label("Add activity", systemImage: "plus")
                }


            HStack {
                List {
                    ForEach(activities) { activity in
                        HStack {
                            Text("\(activity.name!), \(activity.duration)")
                            Text(String(activity.itemArray.count))
                            HStack {
                                ForEach(activity.itemArray, id: \.self) { item in
                                    Text(item.wrappedName)
                                }

                            }
                        }
                        .onTapGesture {
                            if (activity.itemArray.contains(items[0])) {
                             activity.addToItem(items[1])

                            } else {
                                activity.addToItem(items[0])
                            }

                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }
                    .onDelete(perform: deleteActivity)

                }



            }
            }
            
        }
        .tabItem {
            Image(systemName: "plus")
            Text("🎒 Buy")
    }
        
    }
     .environmentObject(self.modules)
     .environmentObject(self.dataFacade)
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func addItem() {
        
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.id = UUID()
            newItem.name = "Item " + randomString(length: 3)
            newItem.itemCategory = itemCategories.randomElement()
            newItem.isInBag = false
            newItem.refillable = false
            newItem.electric = false
            newItem.ultraviolet = false
            self.isInBag.toggle()
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteActivity(offsets: IndexSet) {
        withAnimation {
            offsets.map { activities[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    
    
}
      


//{

//
//    var body: some View {
//

//}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
