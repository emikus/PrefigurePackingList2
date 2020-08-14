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
                trailing:
                Button(action: {
                    if self.activity != nil {
                        self.activity!.name = self.name
                        self.activity!.symbol = self.symbol
                        self.activity!.duration = Int(self.duration)!
                        self.activity!.items = self.activityItems
                        self.activity!.category = self.category
                        
                        self.updateItemsActivitySymbols(activity: self.activity!)
                        
                    } else {
                        let newActivity = Activity(
                            name: self.name,
                            symbol: self.symbol,
                            duration: Int(self.duration)!,
                            items: self.activityItems,
                            category: self.category
                        )
                        
                        self.activities.activities.insert(newActivity, at: 0)
                        self.updateItemsActivitySymbols(activity: newActivity)
                    }
                    
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
    
    func updateItemsActivitySymbols(activity: Activity) {

        for var itemActivitySymbols in self.items.itemsActivitySymbols {

            if activity.items.contains(where: {$0.id == itemActivitySymbols.key}) {

                itemActivitySymbols.value[activity.id] = activity.symbol
                self.items.itemsActivitySymbols[itemActivitySymbols.key]![activity.id] = activity.symbol
                
            } else {

                if let activitySymbolIndex = itemActivitySymbols.value.index(forKey: activity.id)  {
                
                    self.items.itemsActivitySymbols[itemActivitySymbols.key]!.remove(at: activitySymbolIndex)
                    
                }
            }
            
            
            
            
            
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
