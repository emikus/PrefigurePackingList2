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
    @State private var isPinned: Bool = false
    @State private var itemTags:String = ""
    @State private var isExpanded: Bool = false
    @State private var tagsAutoCompleteVisible: Bool = false
    @State private var tagsTextFieldFocused: Bool = false
    @State private var lastTag:String = ""
    @State private var tempItemTagArray: [Tag] = []
    
    func setTagSuggestedIcon(tag: Tag) -> Void {
        let tagNameWithoutHashSymbol = tag.name?.replacingOccurrences(of: "#", with: "")
        
        print("tagNameWithoutHashSymbol", tagNameWithoutHashSymbol)
        print(tagIconSuggestions[tagNameWithoutHashSymbol!])
        if (tagIconSuggestions[tagNameWithoutHashSymbol!] != nil) {
            tag.icon = tagIconSuggestions[tagNameWithoutHashSymbol!]
        }
    }
    
    func splitTagsStringIntoArray(tagsString: String) -> [String] {
        return tagsString.components(separatedBy: " ")
    }
    
    func manageTags(itemTags: [String]) -> Void {
        for tagName in itemTags {
            let tagExists = tags.contains(where: {$0.name == tagName})
            let tagLongEnough = tagName.count > 3
            
            if !tagExists && tagLongEnough {
                let newTag = Tag(context: viewContext)
                newTag.name = tagName
                setTagSuggestedIcon(tag: newTag)
                print ("ICON!!!!!", newTag.icon)
                try? viewContext.save()
            }
        }
    }
    
    func addItemToTags(item: Item,tagsNames: [String]) -> Void {
        
        for tagName in tagsNames {
            let tag = tags.first(where: {$0.name == tagName})
            let tagLongEnough = tagName.count > 3
            
            if tagLongEnough {
                item.addToTag(tag!)
            }
            
        }
    }
    
    func deleteTagsFromItem(item: Item) {
        for tag in tags {
            item.removeFromTag(tag)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        
                        HStack {
                            TextField(
                                "Type to add new or existing tag",
                                text: $itemTags,
                                onEditingChanged: { changing in
                                    tagsTextFieldFocused.toggle()
                                    if tagsTextFieldFocused == false {
                                        tagsAutoCompleteVisible = false
                                    }
                                }
                            )
                            .onChange(of: itemTags) { newValue in
                              
                                let newTagsString = self.itemTags.replacingOccurrences(of: (self.item!.tagArray.map {$0.name!}).joined(separator: " "), with: "")
                                let newTagsArray = newTagsString.byWords
                                let newTag = newTagsArray.last
                                self.lastTag = newTag == nil ? "" : String(newTag!)
                                let lastCharacterInNewTagsStringIsSpaceOrHash = self.itemTags.last == " " || self.itemTags.last == "#"
                                
                                let newTagIsLongEnough = newTag != nil && newTag!.count > 2
                                
                                if tagsTextFieldFocused == true
                                    && newValue != (self.item!.tagArray.map {$0.name!}).joined(separator: " ")
                                    && newTagIsLongEnough == true
                                    && lastCharacterInNewTagsStringIsSpaceOrHash == false {
                                    tagsAutoCompleteVisible = true
                                } else {
                                    tagsAutoCompleteVisible = false
                                }
                            }
                            Button(action: {
                                let tagsNamesArray = splitTagsStringIntoArray(tagsString: self.itemTags)
                                manageTags(itemTags: tagsNamesArray)
                                addItemToTags(item: self.item!, tagsNames: tagsNamesArray)
                                self.itemTags = ""
                            })
                            {
                                Text("Add tags")
                            }
                        }
                        
                        if ((item?.tagArray.count)! > 0) {
                            VStack(alignment: .leading, spacing: 5, content: {
                                HStack {
                                    Text("Item's tags:")
                                    Text("(tap one to disconnect it from the item)")
                                        .font(.footnote)
                                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                                }
                                
                                TagCloudView(
                                    itemTagsString: self.$itemTags,
                                    item: item!,
                                    allTags: false
                                )
                            })
                        }
                        
                        VStack(alignment: .leading, spacing: 5, content: {
                            HStack {
                                Text("All your tags:")
                                Text("(tap one to add it to the item)")
                                    .font(.footnote)
                                    .foregroundColor(selectedThemeColors.fontSecondaryColour)
                            }

                            Collapsible(
                                label: { Text("Collapsible") },
                                content: {
                                    TagCloudView(
                                        itemTagsString: self.$itemTags,
                                        item: item!,
                                        allTags: true
                                    )
                                    .environmentObject(self.selectedThemeColors)
                                }
                            )
                            .frame(maxWidth: .infinity)
                        })
                    }
                    
                    
                    
                    Picker("Item category", selection: $itemCategory) {
                        ForEach(itemCategories, id: \.self) {itemCategory in
                            Text(itemCategory.uppercased())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                    Picker("Module symbol", selection: $moduleSymbol) {
                        ForEach(allModulesSymbols, id: \.self) {moduleSymbol in
                            Text(moduleSymbol)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
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
                
                if tagsAutoCompleteVisible == true {
                    VStack {
                        List {
                            ForEach (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0) && $0.name != self.lastTag && !self.itemTags.contains($0.name!) }, id: \.id) {tag in
                                HStack {
                                    Text(tag.wrappedName)
                                        .onTapGesture {
//                                            withAnimation {
//                                                selectedTag = tag
//                                            }
                                            let tappedTagNameWithoutHash = tag.wrappedName.replacingOccurrences(of: "#", with: "")
                                            
                                            self.itemTags = self.itemTags.replacingLastOccurrenceOfString(self.lastTag, with: tappedTagNameWithoutHash)
                                            tagsAutoCompleteVisible = false
                                        }
//                                    Spacer()
                                }
                                
                            }
                        }
//                        Text(self.lastTag)
//                        if self.lastTag.count > 3 {Text(self.lastTag)}
//                        if self.lastTag.count > 4 {Text(self.lastTag)}
//                        if self.lastTag.count > 5 {Text(self.lastTag)}
//                        if self.lastTag.count > 6 {Text(self.lastTag)}
//                        Text(self.lastTag)
//                    .padding()
                    }
                    .frame(width: 300, height: CGFloat(tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0) && $0.name != self.lastTag && !self.itemTags.contains($0.name!) }.count * 44))
                    .background(Color.red)
                    .position(x: 180, y: CGFloat(450 + (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0)}.count * 22)))
                    .keyboardShortcut(/*@START_MENU_TOKEN@*/KeyEquivalent("a")/*@END_MENU_TOKEN@*/)
                }
                
                
                
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
//                        addItemToTags(item: newItem, tagsNames: tagsNamesArray)
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
        .onAppear(perform: {
            
            if self.item != nil {
                print("PREVIEWWW!!!!!", item)
                self.name = self.item!.wrappedName
                self.weight = String(self.item!.weight)
                self.volume = String(self.item!.volume)
                self.cost = String(self.item!.cost)
                self.batteryConsumption = String(self.item!.batteryConsumption)
                self.itemCategory = self.item!.itemCategory != nil ? self.item?.itemCategory as! String : "food"
                self.symbol = self.item!.wrappedSymbol
                self.moduleSymbol = self.item!.moduleSymbol ?? ""
                self.isPinned = self.item!.isPinned
                self.itemActivities = self.activities.filter {$0.itemArray.filter {$0.id == self.item?.id}.count > 0}
                self.tempItemTagArray = item!.tagArray
//                self.itemTags = (self.item!.tagArray.map {$0.name!}).joined(separator: " ")
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
//                .preferredColorScheme(.dar
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
        let item = Item(context: PersistenceController.preview.container.viewContext)
//        item.name = "dupa"
        AddEditItem(item:item)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
        .environmentObject(SelectedThemeColors())
    }
}
