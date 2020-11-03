//
//  AddEditActivityView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI



struct AddEditActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default)
    private var activities: FetchedResults<Activity>
    var activity:Activity?
    @State var name:String = ""
    @State var symbol: String = ""
    @State var duration:String = ""
    @State var activityItems:[Item] = [Item]()
    @State var category: String = "general"
    @State var itemsNumberDividedByThree = 0
    @State var activitySymbolsSet: [String] = ["pencil.circle", "map", "lock", "hammer", "bitcoinsign.circle", "video", "lightbulb", "sportscourt", "tv.music.note", "book", "dollarsign.circle", "guitars"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Activity's name", text: $name)
                    TextField("Activity's duration", text: $duration)
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                
                Section(header: Text("Activity's symbol, tap to choose.")) {
                    Picker("Symbol", selection: self.$symbol) {
                        ForEach(self.activitySymbolsSet, id: \.self) { symbol in
                            Image(systemName: symbol)
                                .foregroundColor(self.symbol == symbol ? .green : .gray)
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
//
//
//
//                    List {
//                        ForEach(ActivityCategory.allCases, id: \.self) {category in
//
//                            Button(action:{
//                                self.category = category
//                            })
//                            {
//                            HStack {
//                                Text(category.rawValue.uppercased())
//                            }
//                            .foregroundColor(self.category == category ? .green : .gray)
//                            }
//
//                        }
//
//                    }
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
                            .foregroundColor(self.activityItems.contains{$0.id==item.id} ? .green : .gray)
                        }
                    }
                }
                
            }
            .navigationBarTitle(self.activity == nil ? "Add activity" : "Edit activity", displayMode: .inline)
            .navigationBarItems(
                trailing:
                Button(action: {
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
                    }
                    try? viewContext.save()
                    
                }) {
                    Text("Save")
                    Image(systemName: "square.and.arrow.down")
                }
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
