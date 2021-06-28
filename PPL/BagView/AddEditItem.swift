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
    
    @State private var tagsAutoCompleteVisible: Bool = false
    @State private var tagsTextFieldFocused: Bool = false
    @State private var lastTag:String = ""
    @State private var tempItemTagsArray: [Tag] = []
    @State private var allTagsWithoutTempItemTags: [Tag] = []
    @State private var showingCancelingAfterChangesIntroducedAlert = false

        
        
    func getItemHasNotBeenEdited() -> Bool {
        
        if (self.item != nil) {

            return (item!.name == self.name &&
            item!.weight == Int16(self.weight)! &&
            item!.volume == Int16(self.volume)! &&
            item!.cost == Int16(self.cost)! &&
            item!.batteryConsumption == Int16(self.batteryConsumption)! &&
            item!.symbol == self.symbol &&
            item!.itemCategory == self.itemCategory &&
            item!.moduleSymbol == self.moduleSymbol &&
            Set(item!.activityArray) == Set(itemActivities) &&
            Set(item!.tagArray) == Set(tempItemTagsArray))
                
        } else if (self.item == nil) {
            return (self.name == "" &&
                        self.weight == "" &&
                        self.volume == "" &&
                        self.cost == "" &&
                        self.batteryConsumption == "" &&
                        self.symbol == "" &&
                        self.itemCategory == "food" &&
                        self.moduleSymbol == "" &&
                        self.itemActivities.count == 0 &&
                        self.tempItemTagsArray.count == 0
            )
        }
        return true
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
                dataFacade.setTagSuggestedIcon(tag: newTag)
                try? viewContext.save()
                addTagToTempItemTagArray(tag: newTag)
                self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempItemTagsArray.contains($0)}
            } else if tagExists {
                addTagToTempItemTagArray(tag: tags.filter {$0.name == tagName}[0])
            }
        }
    }
    
    func addTagsToItem(item: Item) -> Void {
        for tag in tempItemTagsArray {
            tag.addToItem(item)
        }
    }
    
    func deleteTagsFromItem(item: Item) {
        for tag in tags {
            item.removeFromTag(tag)
        }
    }
    
    
    func actionTest() -> Void {
        print("action Test!!!")
    }
    
    func removeTagFromTempItemTagArray(tag: Tag) -> Void {
        if let index = self.tempItemTagsArray.firstIndex(of: tag) {
            tempItemTagsArray.remove(at: index)
        }
    }
    
    func addTagToTempItemTagArray(tag: Tag) -> Void {
        tempItemTagsArray.insert(tag, at: 0)
    }
    
    func getAllTagsWithoutTempItemTags() -> Array<Tag> {
        return self.tags.filter{!self.tempItemTagsArray.contains($0)}
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
                                },
                                onCommit: {
                                    print("commit!!!!!")
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
                                self.itemTags = ""
                            })
                            {
                                Text("Add tags")
                            }
                            .disabled(self.itemTags.count < 4)
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 5, content: {
                            HStack {
                                Text("Item's tags:")
                                Text("(tap one to disconnect it from the item)")
                                    .font(.footnote)
                                    .foregroundColor(selectedThemeColors.fontSecondaryColour)
                            }
                            
                            TagCloudView(
                                tagsArray: self.$tempItemTagsArray,
                                action: self.removeTagFromTempItemTagArray,
                                actionImageName: "xmark",
                                actionImageColor: Color.red
                            )
                        })
                        
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
                                        tagsArray: self.$allTagsWithoutTempItemTags,
                                        action: self.addTagToTempItemTagArray,
                                        actionImageName: "plus",
                                        actionImageColor: Color.green,
                                        backgroundColor: selectedThemeColors.bgSecondaryColour.opacity(0.8))
                                    .environmentObject(self.selectedThemeColors)
                                }
                            )
                            .frame(maxWidth: .infinity)
                        })
                        .onChange(of: tempItemTagsArray, perform: { value in
                            self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempItemTagsArray.contains($0)}
                            print(allTagsWithoutTempItemTags.count, "tutaj!!!!!!!")
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
                    
                    
                }
                
                if tagsAutoCompleteVisible == true {
                    VStack {
                        List {
                            ForEach (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0) && $0.name != self.lastTag && !self.itemTags.contains($0.name!) && !self.tempItemTagsArray.contains($0) }, id: \.id) {tag in
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
                                }
                                
                            }
                        }
                    }
                    .frame(width: 300, height: CGFloat(tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0) && $0.name != self.lastTag && !self.itemTags.contains($0.name!) && !self.tempItemTagsArray.contains($0) }.count * 44))
                    .background(Color.red)
                    .position(x: 180, y: CGFloat(450 + (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.item!.tagArray.contains($0) && $0.name != self.lastTag && !self.itemTags.contains($0.name!) && !self.tempItemTagsArray.contains($0)}.count * 22)))
                    .keyboardShortcut(/*@START_MENU_TOKEN@*/KeyEquivalent("a")/*@END_MENU_TOKEN@*/)
                }
        }
            .navigationBarTitle(self.item == nil ? "Add item" : "Edit item", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    if (getItemHasNotBeenEdited() == true) {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        showingCancelingAfterChangesIntroducedAlert = true
                    }

                })
                {
                    Text("Cancel")
                        .fontWeight(.light)
                }
                .keyboardShortcut(KeyEquivalent("k")),
                trailing:
                Button(action: {
                    
                    
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
                        addTagsToItem(item: self.item!)
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
                        
                        addTagsToItem(item: newItem)
                        try? viewContext.save()
                    }
                    
                    
                    
                    try? viewContext.save()

                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                    
                }
                .disabled(getItemHasNotBeenEdited())
                .keyboardShortcut(.defaultAction)
            )
        }
        .navigationBarBackButtonHidden(self.item == nil ? true : false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            
            if self.item != nil {
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
                self.tempItemTagsArray = item!.tagArray
                
            }
            self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempItemTagsArray.contains($0)}
            
            self.allModulesSymbols += Array(modules.standBookModeModulesFrontOccupation.keys)
            self.allModulesSymbols += Array(modules.standBookModeModulesBackOccupation.keys)
            self.allModulesSymbols += Array(modules.standMessengerModeModulesFrontOccupation.keys)
            self.allModulesSymbols += Array(modules.standMessengerModeModulesBackOccupation.keys)
            self.allModulesSymbols += Array(modules.strapOneFrontModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapOneBackModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapTwoFrontModulesOccupation.keys)
            self.allModulesSymbols += Array(modules.strapTwoBackModulesOccupation.keys)
        })
        .alert(isPresented: $showingCancelingAfterChangesIntroducedAlert) {
            Alert(
                title: Text("Your changes will be lost😱"),
                message: Text("Do you really wanna loose them?"),
                primaryButton: ActionSheet.Button.default(Text("Oh, thanks, I want to save them first!!!")) { showingCancelingAfterChangesIntroducedAlert = false },
                secondaryButton: ActionSheet.Button.cancel(Text("Don't be overprotective maaaan :)")) { self.presentationMode.wrappedValue.dismiss() }
            )
        }
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
//        AddEditItem()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
        .environmentObject(SelectedThemeColors())
    }
}
