//
//  AddEditItem.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 07/08/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct AddEditActivityView: View {
    @EnvironmentObject var items: Items
    @EnvironmentObject var activities: Activities
    var activity:Activity?
//    @Binding var showAddEditItemView: Bool
    @State var name:String = ""
    @State var symbol: String = ""
    @State var duration:String = ""
    @State var activityItems:[Item] = [Item]()
    @State var category: ActivityCategory = .general
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
                        ForEach(ActivityCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.uppercased())
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
                
                Section(header: Text("Activity's items, tap to toggle. \(String(self.activityItems.count)) chosen already.")) {

                    ForEach (self.items.items)  { item in
                        Button(action:{
                            self.addRemoveActivityItem(item: item)
                        })
                        {
                            HStack {
                                Text(item.name)
                            }
                            .foregroundColor(self.activityItems.contains{$0.id==item.id} ? .green : .gray)
                        }
                    }
                }
                
            }
            .navigationBarTitle(self.activity == nil ? "Add activity" : "Edit activity", displayMode: .inline)
            .navigationBarItems(
//                leading: Button(action: {self.showAddEditItemView = false}) {Text("Cancel")},
                trailing:
                Button(action: {
                    if self.activity != nil {
                        self.activity!.name = self.name
                        self.activity!.symbol = self.symbol
                        self.activity!.duration = Int(self.duration)!
                        self.activity!.items = self.activityItems
                        self.activity!.category = self.category
                        
                    } else {
                        let newActivity = Activity(
                            name: self.name,
                            symbol: self.symbol,
                            duration: Int(self.duration)!,
                            items: self.activityItems,
                            category: self.category
                        )
                                                   
                        
                        self.activities.activities.insert(newActivity, at: 0)
//                        self.items.itemsActivitySymbols[newItem.id] = self.itemActivities.reduce(into: [UUID: String]()) { $0[$1.id] = $1.symbol }
                        
//                        self.addNewItemToActivities(newItem: newItem)
                    }
                    
//                    self.showAddEditItemView = false
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
                self.name = self.activity!.name
                self.symbol = self.activity!.symbol
                self.duration = String(self.activity!.duration)
                self.activityItems = self.activity!.items
                self.category = self.activity!.category
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
        .environmentObject(Items(fillWithSampleData: true))
        .environmentObject(Activities())
        .previewDevice(PreviewDevice(rawValue: "iPhone XR"))
    }
}
