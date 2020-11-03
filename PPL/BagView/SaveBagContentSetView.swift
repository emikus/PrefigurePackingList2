//
//  SaveBagContentSet.swift
//  PPL
//
//  Created by Macbook Pro on 22/10/2020.
//

import SwiftUI

struct SaveBagContentSetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BagContentSet.date, ascending: false)],
        animation: .default)
    private var bagContentSets: FetchedResults<BagContentSet>
    
    @EnvironmentObject var modules: Modules
    @Environment(\.presentationMode) var presentationMode
    @State private var bagContentSetName: String = ""
    
    func saveBagContentSet() {
        
//        print(Mirror(reflecting: self.modules).children)
//
//        for (index, attr) in Mirror(reflecting: self.modules).children.enumerated() {
//            if let property_name = attr.label as String? {
//                print(String(property_name), attr.value, attr.self, String(describing: type(of: attr.value)) == "Published<Dictionary<String, String>>")
//            }
//        }
        let newBagContentSet = BagContentSet(context: viewContext)
        newBagContentSet.date = Date()
        newBagContentSet.name = self.bagContentSetName


        newBagContentSet.addToModulesSet(self.getModulesSet(name: "standBookModeModulesFrontOccupation", modulesToProcess: modules.standBookModeModulesFrontOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "standBookModeModulesBackOccupation", modulesToProcess: modules.standBookModeModulesBackOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "standMessengerModeModulesFrontOccupation", modulesToProcess: modules.standMessengerModeModulesFrontOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "standMessengerModeModulesBackOccupation", modulesToProcess: modules.standMessengerModeModulesBackOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "strapOneFrontModulesOccupation", modulesToProcess: modules.strapOneFrontModulesOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "strapOneBackModulesOccupation", modulesToProcess: modules.strapOneBackModulesOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "strapTwoFrontModulesOccupation", modulesToProcess: modules.strapTwoFrontModulesOccupation))
        
        newBagContentSet.addToModulesSet(self.getModulesSet(name: "strapTwoBackModulesOccupation", modulesToProcess: modules.strapTwoBackModulesOccupation))
        
        
        try? viewContext.save()
    }
    
    func getModulesSet(name: String, modulesToProcess: [String: String]) -> ModulesSet {
        let newModulesSet = ModulesSet(context: viewContext)
        newModulesSet.name = name
        
        for moduleKey in modulesToProcess.keys {
            if modulesToProcess[moduleKey] != "" {
                let itemName = modulesToProcess[moduleKey]
                let newModule = Module(context: viewContext)
                newModule.symbol = moduleKey
           
                newModule.item = self.items.first(where: {$0.name == itemName})
                newModulesSet.addToModule(newModule)
            }
        }
        return newModulesSet
    }
    
    let layout = [
        GridItem(.adaptive(minimum: 105, maximum: 145))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                LazyVGrid(columns: layout, spacing: 15) {
                    ForEach( self.items.filter({$0.isInBag == true})) { item in
                        
                        
                            ItemGridView(item: item)
                        
                    }
                }
                .padding([.leading, .trailing], 10.0)
                .padding(.top, 10.0)
                
                Form {
                    Section(header: Text("If you want to recreate above bag configuration later with just two clicks give it a name and touch Save in the upper right corner")) {
                        TextField("Bag configuration name", text: $bagContentSetName)
                    }
                }
                .background(Color.black)
                .navigationBarTitle("Save bag configuration", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        self.presentationMode.wrappedValue.dismiss()

                    })
                    {
                        Text("Cancel")

                    },
                    trailing:
                        Button(action: {
                            self.saveBagContentSet()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                            Image(systemName: "square.and.arrow.down")
                        }
                    
                )
                
                
            }
            .background(Color.black)
            
            
        }
        .background(Color.black)
        
    }
}

//struct ModulesAndShelvesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModulesAndShelvesView()
//    }
//}



struct SaveBagContentSet: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SaveBagContentSetView_Previews: PreviewProvider {
    static var previews: some View {
        SaveBagContentSetView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
    }
}
