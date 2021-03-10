//
//  ItemsGridView.swift
//  PPL
//
//  Created by Macbook Pro on 13/10/2020.
//


import SwiftUI

@available(iOS 14.0, *)
struct ItemsGridView: View {
    @AppStorage("itemsViewType") var itemsViewType: String = "grid"
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
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
    @State var foodHidden: Bool = false
    @State var categoriesSectionsVisibility:[String:Bool] = [
        "clothes": true,
        "electrical": true,
        "food": true
    ]
    @State var clothesHidden: Bool = false
    @State var electricalHidden: Bool = false
    @State var referenceFoodArray: [GridItemWrapper] = []
    @State var direction:String = "Search..."
    @State var isSearchBarVisible:Bool = false
    @State var searchText = ""
    let itemWidth: CGFloat = 110
    @Binding var scrollToCategoryName: String
    
    
    
    func getItemsToBuyArray(itemsArray: [Item]) -> [GridItemWrapper] {
        var itemsToBuyArray: [FetchedResults<PPL.Item>.Element] = []
        let numberOfItemsInRow = Int((UIScreen.main.bounds.width - 40)/self.itemWidth)
        let numberOfFreeSlotsInRow =  itemsArray.count % numberOfItemsInRow > 0 ? numberOfItemsInRow - (itemsArray.count % numberOfItemsInRow) : 4
        let plusItem = self.items[0]
        let itemToBuy = self.items[0]
        
        itemsToBuyArray.insert(plusItem, at: 0)

        if numberOfFreeSlotsInRow > 1 {
            for _ in 0...numberOfFreeSlotsInRow - 2 {
                itemsToBuyArray.insert(itemToBuy, at: 0)
            }
        }
        
        let allItems = itemsArray.sorted(by: {$0.isInBag && !$1.isInBag}) + itemsToBuyArray
        var allItemsWrapped:[GridItemWrapper] = []
        
        for index in 0...allItems.count - 1 {
            allItemsWrapped.append(GridItemWrapper(id: index, item: allItems[index]))
        }

        return allItemsWrapped
    }
    let layout = [
        GridItem(.adaptive(minimum: 105, maximum: 145))
    ]
    
    func searchFilter(item: Item) -> Bool {
        return self.searchText.count < 3 ? true : item.name!.lowercased().contains(self.searchText.lowercased())
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {

                
                
                ScrollView {
                    ScrollViewReader { scrollView in
                        HStack {
                            if self.isSearchBarVisible == true {
                                SearchBar(text: $searchText)
                                // .padding(.top, -30)
                            }
                            Spacer()
                            Button(action: {
                                self.itemsViewType = "list"
                            }) {
                                Text("List view")
                            }
                            .padding([.trailing], 18)
                            .keyboardShortcut(KeyEquivalent("l"), modifiers: [.command, .option])
                        }
                        
                        
                        
                        HStack {
                            Text("CLOTHES")
                            Image(systemName:self.categoriesSectionsVisibility["clothes"] == false ? "chevron.down" : "chevron.up")
                            Spacer()
                        }
                        .foregroundColor(selectedThemeColors.fontMainColour)
                        .padding([.top,.leading], 15)
                        .onTapGesture {
                            withAnimation{
                                self.categoriesSectionsVisibility["clothes"]?.toggle()
                            }
                        }
                        .id("clothes")
                        
                        if self.categoriesSectionsVisibility["clothes"] == !false {
                            LazyVGrid(columns: layout, spacing: 15) {
                                ForEach(self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "clothes"})).filter({searchFilter(item: $0.item)})) { gridItemWrapper in
                                    
                                    if gridItemWrapper.id < self.items.filter({$0.itemCategory == "clothes"}).count  {
                                        ItemGridView(item: gridItemWrapper.item)
                                    } else {
                                        if gridItemWrapper.id == self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "clothes"})).count - 1 {
                                            BuyItemsGridView()
                                            
                                        } else {
                                            ItemToBuyGridView()
                                        }
                                        
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 10.0)
                            .padding(.top, 10.0)
                        }
                        
                        HStack {
                            Text("ELECTRICAL")
                            Image(systemName:self.categoriesSectionsVisibility["electrical"] == false ? "chevron.down" : "chevron.up")
                            Spacer()
                        }
                        .foregroundColor(selectedThemeColors.fontMainColour)
                        .padding([.top,.leading], 15)
                        .onTapGesture {
                            withAnimation{
                                self.categoriesSectionsVisibility["electrical"]?.toggle()
                            }
                        }
                        .id("electrical")
                        .onChange(of: scrollToCategoryName) { newValue in
                                        print("ItemsGridView: Name changed to \(scrollToCategoryName)!")
                            withAnimation{
                                scrollView.scrollTo(scrollToCategoryName, anchor: .top)
                                self.categoriesSectionsVisibility[scrollToCategoryName] = true
                            }
                        }
                        
                        
                        if self.categoriesSectionsVisibility["electrical"] == true {
                            LazyVGrid(columns: layout, spacing: 15) {
                                ForEach(self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "electrical"})).filter({searchFilter(item: $0.item)})) { gridItemWrapper in
                                    
                                    if gridItemWrapper.id < self.items.filter({$0.itemCategory == "electrical"}).count  {
                                        ItemGridView(item: gridItemWrapper.item)
                                    } else {
                                        if gridItemWrapper.id == self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "electrical"})).count - 1 {
                                            BuyItemsGridView()
                                            
                                        } else {
                                            ItemToBuyGridView()
                                        }
                                        
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 10.0)
                            .padding(.top, 10.0)
                            
                        }
                        
                        HStack {
                            Text("FOOD")
                            Image(systemName:self.categoriesSectionsVisibility["food"] == false ? "chevron.down" : "chevron.up")
                            Spacer()
                        }
                        .foregroundColor(selectedThemeColors.fontMainColour)
                        .padding([.top,.leading], 15)
                        .onTapGesture {
                            withAnimation{
                                self.categoriesSectionsVisibility["food"]?.toggle()
                            }
                        }
                        .id("food")
                        
                        if self.categoriesSectionsVisibility["food"] == true {
                            LazyVGrid(columns: layout, spacing: 15) {
                                ForEach(self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "food"})).filter({searchFilter(item: $0.item)})) { gridItemWrapper in
                                    
                                    if gridItemWrapper.id < self.items.filter({$0.itemCategory == "food"}).count  {
                                        ItemGridView(item: gridItemWrapper.item)
                                    } else {
                                        if gridItemWrapper.id == self.getItemsToBuyArray(itemsArray: self.items.filter({$0.itemCategory == "food"})).count - 1 {
                                            BuyItemsGridView()
                                            
                                        } else {
                                            ItemToBuyGridView()
                                        }
                                        
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 10.0)
                            .padding(.top, 10.0)
                        }
                        
                    }
                }
                .simultaneousGesture(DragGesture()
                                        .onChanged { gesture in
                                           // onChange code
                                            
                                            withAnimation() {
                                                self.isSearchBarVisible = true
                                            }
                                        }
                                     )
                .frame(minHeight: 140)
                .background(selectedThemeColors.bgMainColour)
            }
            
        }
    }
    
    private func onInsert(at offset: Int, itemProvider: [NSItemProvider]) {
        
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

struct ItemsGridView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ItemsGridView(scrollToCategoryName: .constant(""))
                .previewDevice("iPad Pro (9.7-inch)")
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(Modules())
                .environmentObject(SelectedThemeColors())
        } else {
            // Fallback on earlier versions
        }
    }
}

