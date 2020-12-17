//
//  BagContentSetsListView.swift
//  PPL
//
//  Created by Macbook Pro on 22/10/2020.
//

import SwiftUI

struct BagContentSetsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BagContentSet.date, ascending: false)],
        animation: .default)
    private var bagContentSets: FetchedResults<BagContentSet>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ModulesSet.name, ascending: false)],
        animation: .default)
    private var modulesSet: FetchedResults<ModulesSet>

    @EnvironmentObject var modules: Modules
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var dataFacade: DataFacade
    @Environment(\.presentationMode) var presentationMode

    func getItemsFromBagContentSet(bagContentSet: BagContentSet) -> [Item] {
        let items: [Item] = bagContentSet.modulesSetArray.flatMap({
            $0.modulesArray.compactMap({$0.item})
        })
        
        print(modulesSet.count)
        return items
    }
    
    var body: some View {
        NavigationView {
        List {
                        ForEach(self.bagContentSets, id:\.self) { bagContentSet in
                            HStack {
                                Text(bagContentSet.name!)
                                Spacer()
                                ForEach(self.getItemsFromBagContentSet(bagContentSet: bagContentSet)) {item in
                                    Text(item.symbol!)
                                    .padding(3)
                                    .font(.system(size: 20))
                                    .contentShape(Rectangle())
                                    .background(Color(red: 0/255, green: 0/255, blue: 0/255))
                                        .cornerRadius(5)
                                }
                            }
                            .onTapGesture(count: 1, perform: {
    //                            self.dataFacade.testCoreData()
                                
                                self.items.filter({$0.isInBag == true}).forEach { item in
                                    item.isInBag = false
                                    self.modules.addRemoveItemToModule(item: item)
                                }
                                
                                self.activities.filter({$0.isSelected == true}).forEach { activity in
                                    activity.isSelected = false
                                }
                                
                                let modulesAndTheirItems = self.dataFacade.getBagContentSetModulesAndTheirItems(bagContentSetName: bagContentSet.name!)
                                var itemsToAddToBag: [Item] = []
                                
                                modulesAndTheirItems.forEach { (key, value) in
                                    itemsToAddToBag += Array(value.values)
                                }
                            
                                itemsToAddToBag.forEach { item in
                                    item.isInBag = true
                                    item.isInModuleSlot = true
                                }
                                
                                modules.recreateBagContentSet(modulesAndTheirItems: modulesAndTheirItems)
                                self.presentationMode.wrappedValue.dismiss()
                            })
                        }
                        .onDelete(perform: deleteBagContentSet)
                        
                    }
        .navigationBarTitle("Recreate bag content", displayMode: .inline)
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            {
                Text("Cancel")
            }
            .keyboardShortcut(KeyEquivalent("c"))
        )
            
        }
    }
    
    private func deleteBagContentSet(offsets: IndexSet) {
        withAnimation {
            
            let modulesSetToDelete = offsets.map{bagContentSets[$0] }[0].modulesSet
            
            for moduleSet in modulesSetToDelete! {
                let mS = moduleSet as! ModulesSet

                // delete all modules in the bagContentSet's modulesSet
                for module in mS.module! {
                    viewContext.delete(module as! Module)
                }
                
                // delete all modulesSet in the bagContentSet
                viewContext.delete(mS)
            }
            
            // delete the bagContentSet itself
            offsets.map {bagContentSets[$0] }.forEach(viewContext.delete)

            try? viewContext.save()
        }
    }
}

struct BagContentSetsListView_Previews: PreviewProvider {
    static var previews: some View {
        BagContentSetsListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
    }
}
