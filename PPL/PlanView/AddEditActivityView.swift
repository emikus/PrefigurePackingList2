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
    @State private var activityTags = ""
    @State private var isExpanded: Bool = false
    
    private func endEditing() {
            UIApplication.shared.endEditing()
    }
    
    func splitTagsStringIntoArray(tagsString: String) -> [String] {
        return tagsString.components(separatedBy: " ")
    }
    
    func manageTags(activityTags: [String]) -> Void {
        for tagName in activityTags {
            let tagExists = tags.contains(where: {$0.name == tagName})
            
            if !tagExists {
                let newTag = Tag(context: viewContext)
                newTag.name = tagName
                try? viewContext.save()
            }
        }
    }
    
    func addActivityToTags(activity: Activity,tagsNames: [String]) -> Void {
        for tagName in tagsNames {
            let tag = tags.first(where: {$0.name == tagName})

            activity.addToTag(tag!)
        }
    }
    
    func deleteAllTagsFromActivity(activity: Activity) {
        for tag in tags {
            activity.removeFromTag(tag)
        }
    }
    
    
    var body: some View {
        NavigationView {
            
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
                
                Section (header: Text("Tags")){

                    TextField("Activity's tags", text: $activityTags)
                    
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
                
                Section(header: Text("Activity's symbol, tap to choose.")) {
                    Picker("Symbol", selection: self.$symbol) {
                        ForEach(self.activitySymbolsSet, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .foregroundColor(self.symbol == symbol ? selectedThemeColors.elementActiveColour : selectedThemeColors.fontSecondaryColour)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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
                    print("dupa")
                    self.presentationMode.wrappedValue.dismiss()
                    
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
                        addActivityToTags(activity: self.activity!, tagsNames: tagsNamesArray)
                        
                    } else {
                        // adding new activity
                        let newActivity = Activity(context: viewContext)
                        newActivity.id = UUID()
                        newActivity.name = self.name
                        newActivity.symbol = self.symbol



                        newActivity.duration = Int16(self.duration)!
//                        newActivity.items = self.activityItems
                        newActivity.category = self.category
                        newActivity.isSelected = false
                        
                        for item in activityItems {
                            newActivity.addToItem(item)
                        }
                        
                        addActivityToTags(activity: newActivity, tagsNames: tagsNamesArray)
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
        .navigationBarBackButtonHidden(self.activity == nil ? true : false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            if self.activity != nil {
                self.name = self.activity!.name!
                self.symbol = self.activity!.symbol!
                self.duration = String(self.activity!.duration)
                self.activityItems = self.activity!.itemArray
                self.category = self.activity!.category!
                self.activityTags = (self.activity!.tagArray.map {$0.name!}).joined(separator: " ")
            }
        })
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
    }
}
