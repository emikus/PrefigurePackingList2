//
//  ItemsListView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI


struct ItemsListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var modules: Modules
    @State var showAddEditItemView = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        

            VStack {

                List {
                    Section(header:
                                Text(self.items.filter({$0.isPinned == true}).count == 0 ? "Long press the item to add it here" : "Your favourite items")
                            .foregroundColor(.orange)) {
                        ForEach(self.items.filter({$0.isPinned == true}).sorted(by: {$0.isInBag && !$1.isInBag})) { item in
                                    ItemListView(item: item)
                                }
                                .listRowBackground(Color(red: 28/255, green: 29/255, blue: 31/255))
                    }
                    Section(header:
                        Text("All your items")
                            .foregroundColor(.orange)) {
                        ForEach(self.items.sorted(by: {$0.isInBag && !$1.isInBag})) { item in
                                    ItemListView(item: item)

                                }

                                .onInsert(of: ["ppl.item"], perform: onInsert)
                                .background(Color.black)
                                .listRowBackground(Color(red: 28/255, green: 29/255, blue: 31/255))

                    }
                    .background(Color.black)

                }
                .background(Color.black)

            }
            .listStyle(GroupedListStyle())
        
        
    }
//    }
    
    private func onInsert(at offset: Int, itemProvider: [NSItemProvider]) {
        print(dNdSourceView)

        if let ip = itemProvider.first {
            ip.loadObject(ofClass: Item.self) { reading, _ in
                guard let item = reading as? Item else { return }
                DispatchQueue.main.async {
                    let originalItem = self.items.filter{ $0.id == item.id }.first!

                    if dNdSourceView == .modules {
                        originalItem.isInBag = false
                    self.modules.addRemoveItemToModule(item: originalItem)

                    } else if dNdSourceView == .smartShelf {
//                        self.items.addRemoveItemFromTheShelf(item: originalItem)
                    }
                }
            }
        }
    }
    
   
    
    
    
    
}


struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(Modules())
    }
}
