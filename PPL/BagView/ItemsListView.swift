//
//  ItemsListView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI


struct ItemsListView: View {
    @AppStorage("itemsViewType") var itemsViewType: String = "list"
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
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State var showAddEditItemView = false
    @State var direction:String = "Search..."
    @State var isSearchBarVisible:Bool = false
    @State var searchText = ""
    
    
    func searchFilter(item: Item) -> Bool {
        return self.searchText.count < 3 ? true : item.name!.lowercased().contains(self.searchText.lowercased())
    }

    var body: some View {
        
        

        VStack {
            
            List {
                HStack {
                    if self.isSearchBarVisible == true {
                        SearchBar(text: $searchText)
                    }
                    Spacer()
                    
                    Button(action: {
                        self.itemsViewType = "grid"
                    }) {
                        Text("Grid view")
                    }
                    .keyboardShortcut(KeyEquivalent("l"), modifiers: [.command, .option])
                    
                    
                }
                .listRowBackground(selectedThemeColors.bgMainColour)
                .padding(.leading, -15)
                
                if self.searchText.count < 3 {
                    Section(header: HStack{
                        Text(self.items.filter({$0.isPinned == true}).count == 0 ? "Long press the item to add it here" : "Your favourite items")
                            .foregroundColor(selectedThemeColors.listHeaderColour)
                            .padding()
                        
                        Spacer()
                    }
                    .background(selectedThemeColors.bgMainColour)
                    .listRowInsets(EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0))) {
                        ForEach(self.items.filter({$0.isPinned == true}).sorted(by: {$0.isInBag && !$1.isInBag})) { item in
                            ItemListView(item: item)
                        }
                        .listRowBackground(selectedThemeColors.bgSecondaryColour)
                    }
                }
                
                Section(header: HStack {
                    Text("All your items")
                        .foregroundColor(selectedThemeColors.listHeaderColour)
                        .padding()
                    
                    Spacer()
                }
                .background(selectedThemeColors.bgMainColour)
                .listRowInsets(EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: 0,
                                trailing: 0))
                
                ) {
                    ForEach(self.items.sorted(by: {$0.isInBag && !$1.isInBag}).filter({searchFilter(item: $0)})) { item in
                        ItemListView(item: item)
                        
                    }
                    .onDelete(perform: { indexSet in
                        print(indexSet)
                    })
                    .onInsert(of: ["ppl.item"], perform: onInsert)
                    .listRowBackground(selectedThemeColors.bgSecondaryColour)
                    
                    
                }
                
            }
            //                .preferredColorScheme(.light)
            .padding(.top, -47)
            .simultaneousGesture(DragGesture()
                                    .onChanged { gesture in
                                        // onChange code
                                        withAnimation() {
                                            self.isSearchBarVisible = true
                                        }
                                    }
                                    .onEnded {_ in
                                        print("ended")
                                    }
            )
            .background(Color.yellow)
        }
            .listStyle(GroupedListStyle())
            .background(Color.yellow)
    }
    
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
            .environmentObject(SelectedThemeColors())

    }
}

