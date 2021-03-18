//
//  AddEditItem.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI

struct AddEditItem: View {
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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @EnvironmentObject var modules: Modules
    var item:Item?
    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var dataFacade: DataFacade
    @State private var name:String = ""
    @State private var weight:String = ""
    @State private var volume:String = ""
    @State private var cost:String = ""
    @State private var batteryConsumption:String = ""
    @State private var symbol:String = ""
    @State private var moduleSymbol:String = ""
    @State private var itemCategory = "food"
    @State private var itemActivities:[Activity] = [Activity]()
    @State private var allModulesSymbols = [""]
    @State private var isPinned = false
    @State private var itemTags = ""
    @State private var isExpanded: Bool = false
    
    func splitTagsStringIntoArray(tagsString: String) -> [String] {
        return tagsString.components(separatedBy: " ")
    }
    
    func manageTags(itemTags: [String]) -> Void {
        for tagName in itemTags {
            let tagExists = tags.contains(where: {$0.name == tagName})
            
            if !tagExists {
                let newTag = Tag(context: viewContext)
                newTag.name = tagName
                try? viewContext.save()
            }
        }
    }
    
    func addItemToTags(item: Item,tagsNames: [String]) -> Void {
        for tagName in tagsNames {
            let tag = tags.first(where: {$0.name == tagName})

            item.addToTag(tag!)
        }
    }
    
    func deleteTagsFromItem(item: Item) {
        for tag in tags {
            item.removeFromTag(tag)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item's name", text: $name)
                    TextField("Item's weight", text: $weight)
                    .keyboardType(UIKeyboardType.decimalPad)
                    TextField("Item's volume", text: $volume)
                    .keyboardType(UIKeyboardType.decimalPad)
                    TextField("Item's cost", text: $cost)
                    .keyboardType(UIKeyboardType.decimalPad)
                    TextField("Item's battery consumption", text: $batteryConsumption)
                    .keyboardType(UIKeyboardType.decimalPad)
                    TextField("Item's symbol", text: $symbol)
                }
                
                Section (header: Text("Tags")){
//                    if self.item != nil {
//                        ForEach (item!.tagArray, id: \.id) {tag in
//                            Text(tag.wrappedName)
//                        }
//                    }
//                    ForEach (tags, id: \.id) {tag in
//                        Text(tag.wrappedName)
//                    }
                    TextField("Item's tags", text: $itemTags)
                    
//                    TagCloudView(tags: tags.map {$0.name!})
                    Text(tags.map {$0.name!}.joined(separator: " "))
                                .lineLimit(isExpanded ? nil : 1)
                                .overlay(
                                    GeometryReader { proxy in
                                        Button(action: {
                                            
                                                isExpanded.toggle()
                                        }) {
                                            Text(isExpanded ? "Less" : "More")
                                                .font(.caption).bold()
                                                .padding(.leading, 8.0)
                                                .padding(.top, 4.0)
//                                                .background(Color.white)
                                        }
                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                                    }
                                )
                            
//
                    
//                    .frame(height: 23)
                }

                Picker("Item category", selection: $itemCategory) {
                    ForEach(itemCategories, id: \.self) {itemCategory in
                    Text(itemCategory.uppercased())
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Picker("Module symbol", selection: $moduleSymbol) {
                    ForEach(allModulesSymbols, id: \.self) {moduleSymbol in
                    Text(moduleSymbol)
                    }
                }.pickerStyle(MenuPickerStyle())

                Section(header: Text("Item's activities, tap to toggle. \(String(self.itemActivities.count)) chosen already.")) {
                        ForEach (self.activities)  { activity in
                            Button(action:{
                                self.addRemoveItemActivity(activity: activity)
                            })
                            {
                            HStack {
                                Image(systemName: activity.wrappedSymbol)
                                Text(activity.wrappedName)

                            }
                            .foregroundColor(self.itemActivities.contains{$0.id==activity.id} ? selectedThemeColors.elementActiveColour : selectedThemeColors.fontSecondaryColour)
                        }
                    }
                }
                
//                Button(action: {
//                    self.presentationMode.wrappedValue.dismiss()
//
//                })
//                {
//                    Text("Cancel")
//                }
//                .keyboardShortcut(.cancelAction)

            }
            .navigationBarTitle(self.item == nil ? "Add item" : "Edit item", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()

                })
                {
                    Text("Cancel")
                }
                .keyboardShortcut(KeyEquivalent("k")),
                trailing:
                Button(action: {
                    
                    let tagsNamesArray = splitTagsStringIntoArray(tagsString: self.itemTags)
                    
                    print(splitTagsStringIntoArray(tagsString: self.itemTags))
                    manageTags(itemTags: tagsNamesArray)
                    
                    if self.item != nil {
                        self.item!.name = self.name
                        self.item!.weight = Int16(self.weight)!
                        self.item!.volume = Int16(self.volume)!
                        self.item!.cost = Int16(self.cost)!
                        self.item!.batteryConsumption = Int16(self.batteryConsumption)!
                        self.item!.symbol = self.symbol
                        self.item!.itemCategory = self.itemCategory
                        self.item!.moduleSymbol = self.moduleSymbol
                        self.item!.isPinned = self.isPinned
                        self.item!.electric = false
                        self.item!.refillable = false
                        self.item!.ultraviolet = false

                        dataFacade.updateItemActivities(item: self.item!, itemActivities: self.itemActivities)
                        
                        deleteTagsFromItem(item: self.item!)
                        addItemToTags(item: self.item!, tagsNames: tagsNamesArray)
                    } else {
                        let newItem = Item(context: viewContext)
                        newItem.id = UUID()
                        newItem.name = self.name
                        newItem.weight = Int16(self.weight)!
                        newItem.volume = Int16(self.volume)!
                        newItem.cost = Int16(self.cost)!
                        newItem.batteryConsumption = Int16(self.batteryConsumption)!
                        newItem.symbol = self.symbol
                        newItem.itemCategory = self.itemCategory
                        newItem.moduleSymbol = self.moduleSymbol
                        newItem.refillable = false
                        newItem.electric = false
                        newItem.ultraviolet = false

                        dataFacade.addNewItemToActivities(newItem: newItem, itemActivities: self.itemActivities)
                        addItemToTags(item: newItem, tagsNames: tagsNamesArray)
//                        addTagsToItem(tagsNames: tagsNamesArray, item: newItem)
                    }
                    
                    
                    
                    try? viewContext.save()

                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                    Image(systemName: "square.and.arrow.down")
                }
                .keyboardShortcut(.defaultAction)
            )
        }
        .navigationBarBackButtonHidden(self.item == nil ? true : false)
        .navigationViewStyle(StackNavigationViewStyle())
//        // .preferredColorScheme(.light)
        .onAppear(perform: {
//            for tag in tags {
//                viewContext.delete(tag)
//                try? viewContext.save()
//            }
            
            
            
            if self.item != nil {
                self.name = self.item!.name!
                self.weight = String(self.item!.weight)
                self.volume = String(self.item!.volume)
                self.cost = String(self.item!.cost)
                self.batteryConsumption = String(self.item!.batteryConsumption)
                self.itemCategory = self.item!.itemCategory!
                self.symbol = self.item!.wrappedSymbol
                self.moduleSymbol = self.item!.moduleSymbol ?? ""
                self.isPinned = self.item!.isPinned
                self.itemActivities = self.activities.filter {$0.itemArray.filter {$0.id == self.item?.id}.count > 0}
                self.itemTags = (self.item!.tagArray.map {$0.name!}).joined(separator: " ")
            }
            
            self.allModulesSymbols += Array(modules.standBookModeModulesFrontOccupation.keys)
            self.allModulesSymbols += Array(modules.standBookModeModulesBackOccupation.keys)
            self.allModulesSymbols += Array(modules.standMessengerModeModulesFrontOccupation.keys)
            self.allModulesSymbols += Array(modules.standMessengerModeModulesBackOccupation.keys)
            self.allModulesSymbols += Array(modules.strapOneFrontModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapOneBackModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapTwoFrontModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapTwoBackModulesOccupation.keys)
        })
                .preferredColorScheme(.dark)
//                .onAppear(perform: {
//                    changeColorTheme(theme: themes[0].themeColours)
//                })
    }
    
    func addRemoveItemActivity(activity: Activity) {
        if self.itemActivities.contains(activity) {
            self.itemActivities.removeAll {$0.id == activity.id}
        } else {
            self.itemActivities.append(activity)
        }
    }
}

struct AddEditItem_Previews: PreviewProvider {
    static var previews: some View {
        AddEditItem()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
            .environmentObject(SelectedThemeColors())
    }
}
