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
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
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
        PreferencesView()
             .tabItem {
                 Image(systemName: "plus")
                 Text("⭕️ Aim")
             }
         
         PlanView()
             .tabItem {
                 Image(systemName: "plus")
                 Text("🟥 Plan")
             }
         
        KeyboardShortcutsView()
             .tabItem {
                 Image(systemName: "plus")
                 .font(.largeTitle)
         }
         
         BagView()
             .tabItem {
                 Image(systemName: "plus")
                 Text("🗄 Pack")
         }
        
        
        
        
         
        
        .tabItem {
            Image(systemName: "plus")
            Text("🎒 Buy")
        }
        
        PreferencesView()
            .tabItem {
                Image(systemName: "plus")
                Text("⚙️ Preferences")
            }
        
    }
     .environmentObject(self.modules)
     .environmentObject(self.dataFacade)
        }
    }
    
    func randomString(length: Int) -> String {
        
        UIApplication.shared.alternateIconName
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
