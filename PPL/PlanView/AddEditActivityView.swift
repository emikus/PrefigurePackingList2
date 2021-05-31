//
//  AddEditActivityView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct AddEditActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    var activity:Activity?
    @Environment(\.presentationMode) var presentationMode
    @State var name:String = ""
    @State var symbol: String = ""
    @State var duration:String = ""
    @State var activityItems:[Item] = [Item]()
    @State var category: String = "general"
    @State var itemsNumberDividedByThree = 0
    @State var activitySymbolsSet: [String] = ["pencil.circle", "map", "lock", "hammer", "bitcoinsign.circle", "video", "lightbulb", "sportscourt", "tv.music.note", "book", "dollarsign.circle", "guitars"]
    @State private var isExpanded: Bool = false
    @State private var activityTags:String = ""
    @State private var tagsAutoCompleteVisible: Bool = true
    @State private var tagsTextFieldFocused: Bool = false
    @State private var lastTag:String = ""
    @State private var tempActivityTagsArray: [Tag] = []
    @State private var allTagsWithoutTempItemTags: [Tag] = []
    @State private var showingCancelingAfterChangesIntroducedAlert = false
    
    func getActivityHasNotBeenEdited() -> Bool {
        
        if (self.activity != nil) {

            return (activity!.name == self.name &&
                        activity!.symbol == self.symbol &&
                        activity!.duration == Int16(self.duration)! &&
                        activity!.category == self.category &&
                    Set(activity!.tagArray) == Set(tempActivityTagsArray) &&
                        Set(activity!.itemArray) == Set(activityItems)
            )
        } else if (self.activity == nil) {
            return (self.name == "" &&
                self.symbol == "" &&
                self.duration == "" &&
                self.category == "general" &&
                self.activityItems.count == 0 &&
                self.tempActivityTagsArray.count == 0
    )
                        
        }
        return true
    }
    
    
    private func endEditing() {
            UIApplication.shared.endEditing()
    }
    
    func splitTagsStringIntoArray(tagsString: String) -> [String] {
        return tagsString.components(separatedBy: " ")
    }
    
    func manageTags(activityTags: [String]) -> Void {
        for tagName in activityTags {
            let tagExists = tags.contains(where: {$0.name == tagName})
            let tagLongEnough = tagName.count > 3
            
            if !tagExists && tagLongEnough {
                let newTag = Tag(context: viewContext)
                newTag.name = tagName
                dataFacade.setTagSuggestedIcon(tag: newTag)
                try? viewContext.save()
                addTagToTempItemTagArray(tag: newTag)
                self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempActivityTagsArray.contains($0)}
            } else if tagExists {
                addTagToTempItemTagArray(tag: tags.filter {$0.name == tagName}[0])
            }
        }
    }
    
    func addTagsToActivity() -> Void {
        for tag in tempActivityTagsArray {
            tag.addToActivity(activity!)
        }
    }
    
    func deleteAllTagsFromActivity(activity: Activity) {
        for tag in tags {
            activity.removeFromTag(tag)
        }
    }
    
    func removeTagFromTempItemTagArray(tag: Tag) -> Void {
        if let index = self.tempActivityTagsArray.firstIndex(of: tag) {
            tempActivityTagsArray.remove(at: index)
        }
    }
    
    func addTagToTempItemTagArray(tag: Tag) -> Void {
        tempActivityTagsArray.insert(tag, at: 0)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
            Form {

                Section {
                    TextField("Activity's name", text: $name, onCommit: {
                        print("act name")
                        UIApplication.shared.endEditing()
                    })
                    TextField("Activity's duration", text: $duration, onCommit: {
                        print("duration")
                        UIApplication.shared.endEditing()
                    })
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                .onTapGesture {
                    self.endEditing()
                }
                
                Section(header: Text("Activity's symbol, tap to choose.")) {
                    Picker("Symbol", selection: self.$symbol) {
                        ForEach(self.activitySymbolsSet, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .foregroundColor(self.symbol == symbol ? selectedThemeColors.elementActiveColour : selectedThemeColors.fontSecondaryColour)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }
                
                Section (header: Text("Tags")) {
                    
                    HStack {
                        TextField(
                            "Type to add new or existing tag",
                            text: $activityTags,
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
                        .onChange(of: activityTags) { newValue in
                          
                            let newTagsString = self.activityTags.replacingOccurrences(of: (self.activity!.tagArray.map {$0.name!}).joined(separator: " "), with: "")
                            let newTagsArray = newTagsString.byWords
                            let newTag = newTagsArray.last
                            self.lastTag = newTag == nil ? "" : String(newTag!)
                            let lastCharacterInNewTagsStringIsSpaceOrHash = self.activityTags.last == " " || self.activityTags.last == "#"
                            
                            let newTagIsLongEnough = newTag != nil && newTag!.count > 2
                            
                            if tagsTextFieldFocused == true
                                && newValue != (self.activity!.tagArray.map {$0.name!}).joined(separator: " ")
                                && newTagIsLongEnough == true
                                && lastCharacterInNewTagsStringIsSpaceOrHash == false {
                                tagsAutoCompleteVisible = true
                            } else {
                                tagsAutoCompleteVisible = false
                            }
                        }
                        Button(action: {
                            let tagsNamesArray = splitTagsStringIntoArray(tagsString: self.activityTags)
                            manageTags(activityTags: tagsNamesArray)
                            self.activityTags = ""
                        })
                        {
                            Text("Add tags")
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        HStack {
                            Text("Activity's tags:")
                            Text("(tap one to disconnect it from the activity)")
                                .font(.footnote)
                                .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        }

                        TagCloudView(
                            tagsArray: self.$tempActivityTagsArray,
                            action: self.removeTagFromTempItemTagArray,
                            actionImageName: "xmark",
                            actionImageColor: Color.red)
                    })
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        HStack {
                            Text("All your tags:")
                            Text("(tap one to add it to the activity)")
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
                                    actionImageColor: Color.green)
                                .environmentObject(self.selectedThemeColors)
                            }
                        )
                        .frame(maxWidth: .infinity)
                    })
                    .onChange(of: tempActivityTagsArray, perform: { value in
                        self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempActivityTagsArray.contains($0)}
                        print(allTagsWithoutTempItemTags.count, "tutaj!!!!!!!")
                    })
                }
                
                Section(header: Text("Activity's category, tap to choose.")) {
                    
                    Picker("Symbol", selection: self.$category) {
                        ForEach(activitiesCategories, id: \.self) { category in
                            Text(category.uppercased())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Activity's items, tap to toggle. \(String((self.activityItems.count))) chosen already."), footer: Text("footer nice one")) {

                    ForEach (self.items)  { item in
                        Button(action:{
                            self.addRemoveActivityItem(item: item)
                        })
                        {
                            HStack {
                                Text(item.wrappedName)
                            }
                            .foregroundColor(self.activityItems.contains{$0.id==item.id} ? selectedThemeColors.elementActiveColour : selectedThemeColors.fontSecondaryColour)
                        }
                    }
                }
                
                
                
                
            }
            
            .navigationBarTitle(self.activity == nil ? "Add activity" : "Edit activity", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    if (getActivityHasNotBeenEdited() == true) {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        showingCancelingAfterChangesIntroducedAlert = true
                    }
                    
                })
                {
                    Text("Cancel")
                }
                .keyboardShortcut(KeyEquivalent(",")),
                trailing:
                Button(action: {
                    let tagsNamesArray = splitTagsStringIntoArray(tagsString: self.activityTags)
                    manageTags(activityTags: tagsNamesArray)
                    // activity edition
                    if self.activity != nil {
                        
                        self.activity!.name = self.name
                        self.activity!.symbol = self.symbol
                        self.activity!.duration = Int16(self.duration)!
                        self.activity!.category = self.category
                        self.activity?.removeFromItem((self.activity?.item)!)
                        for item in activityItems {
                            self.activity!.addToItem(item)
                        }
                        deleteAllTagsFromActivity(activity: self.activity!)
                    } else {
                        // adding new activity
                        let newActivity = Activity(context: viewContext)
                        newActivity.id = UUID()
                        newActivity.name = self.name
                        newActivity.symbol = self.symbol



                        newActivity.duration = Int16(self.duration)!
                        newActivity.category = self.category
                        newActivity.isSelected = false
                        
                        for item in activityItems {
                            newActivity.addToItem(item)
                        }
                    }
                    addTagsToActivity()
                    
                    try? viewContext.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Save")
                }
                .disabled(getActivityHasNotBeenEdited())
                .keyboardShortcut(.defaultAction)
            )
                
                if tagsAutoCompleteVisible == true {
                    VStack {
                        List {
                            ForEach (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.activity!.tagArray.contains($0) && $0.name != self.lastTag && !self.activityTags.contains($0.name!) && !self.tempActivityTagsArray.contains($0) }, id: \.id) {tag in
                                HStack {
                                    Text(tag.wrappedName)
                                        .onTapGesture {
//                                            withAnimation {
//                                                selectedTag = tag
//                                            }
                                            let tappedTagNameWithoutHash = tag.wrappedName.replacingOccurrences(of: "#", with: "")
                                            
                                            self.activityTags = self.activityTags.replacingLastOccurrenceOfString(self.lastTag, with: tappedTagNameWithoutHash)
                                            tagsAutoCompleteVisible = false
                                        }
                                }
                                
                            }
                        }
                        .border(Color.green)
                    }
                    .border(Color.red)
                    .frame(width: 300, height: CGFloat(tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.activity!.tagArray.contains($0) && $0.name != self.lastTag && !self.activityTags.contains($0.name!) && !self.tempActivityTagsArray.contains($0)}.count * 44))
                    .position(x: 180, y: CGFloat(340 + (tags.filter{ $0.name!.range(of: self.lastTag, options: .caseInsensitive) != nil && !self.activity!.tagArray.contains($0) && !self.tempActivityTagsArray.contains($0)}.count * 22)))
                    .keyboardShortcut(/*@START_MENU_TOKEN@*/KeyEquivalent("a")/*@END_MENU_TOKEN@*/)
                }
        }
        }
        .navigationBarBackButtonHidden(self.activity == nil ? true : false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            if self.activity != nil {
                self.name = self.activity!.name!
                self.symbol = self.activity!.symbol!
                self.duration = String(self.activity!.duration)
                self.activityItems = self.activity!.itemArray
                self.category = self.activity!.category!
                self.tempActivityTagsArray = activity!.tagArray
            }
            
            self.allTagsWithoutTempItemTags = self.tags.filter{!self.tempActivityTagsArray.contains($0)}
        })
        .alert(isPresented: $showingCancelingAfterChangesIntroducedAlert) {
            Alert(
                title: Text("Your changes will be lost😱"),
                message: Text("Do you really wanna loose them?"),
                primaryButton: ActionSheet.Button.default(Text("Oh, thanks, I want to save them first!!!")) { showingCancelingAfterChangesIntroducedAlert = false },
                secondaryButton: ActionSheet.Button.cancel(Text("Don't be overprotective maaaan :)")) { self.presentationMode.wrappedValue.dismiss() }
            )
        }
    }
    
    func addRemoveActivityItem(item: Item) {
        if self.activityItems.contains(item) {
            self.activityItems.removeAll {$0.id == item.id}
        } else {
            self.activityItems.append(item)
        }
    }
}

struct AddEditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditActivityView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(Modules())
            .environmentObject(SelectedThemeColors())
    }
}
