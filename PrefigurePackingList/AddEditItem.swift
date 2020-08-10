//
//  AddEditItem.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 07/08/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct AddEditItem: View {
    @EnvironmentObject var items: Items
    @EnvironmentObject var activities: Activities
    var item:Item?
    @Binding var showAddEditItemView: Bool
    @State private var name:String = ""
    @State private var weight:String = ""
    @State private var volume:String = ""
    @State private var itemActivities:[Activity] = [Activity]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Item's name", text: $name)
                    TextField("Item's weight", text: $weight)
                    .keyboardType(UIKeyboardType.decimalPad)
                    TextField("Item's volume", text: $volume)
                    .keyboardType(UIKeyboardType.decimalPad)
                }
                Section(header: Text("Item's activities, tap to toggle. \(String(self.itemActivities.count)) chosen already.")) {
                        ForEach (self.activities.activities)  { activity in
                            Button(action:{
                                self.addRemoveItemActivity(activity: activity)
                            })
                            {
                            HStack {
                                Image(systemName: activity.symbol)
                                Text(activity.name)
                                    
                            }
                            .foregroundColor(self.itemActivities.contains{$0.id==activity.id} ? .green : .gray)
                        }
                    }
                }
                
            }
            .navigationBarTitle(self.item == nil ? "Add item" : "Edit item", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {self.showAddEditItemView = false}) {Text("Cancel")},
                trailing:
                Button(action: {
                    if self.item != nil {
                        self.item!.name = self.name
                        self.item!.weight = Int(self.weight)!
                        self.item!.volume = Int(self.volume)!
                        self.items.itemsActivitySymbols[self.item!.id] = self.itemActivities.reduce(into: [UUID: String]()) { $0[$1.id] = $1.symbol }
                        
                        self.updateItemActivities()
                        
                    } else {
                        let newItem = Item(name: self.name, weight: Int(self.weight)!, volume: Int(self.volume)!, activities: [1,2,3])
                        
                        self.items.items.insert(newItem, at: 0)
                        self.items.itemsActivitySymbols[newItem.id] = self.itemActivities.reduce(into: [UUID: String]()) { $0[$1.id] = $1.symbol }
                        
                        self.addNewItemToActivities(newItem: newItem)
                    }
                    
                    self.showAddEditItemView = false
                }) {
                    Text("Save")
                    Image(systemName: "square.and.arrow.down")
                }
            )
        }
        .navigationBarBackButtonHidden(self.item == nil ? true : false)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            if self.item != nil {
                self.name = self.item!.name
                self.weight = String(self.item!.weight)
                self.volume = String(self.item!.volume)
                self.itemActivities = self.activities.activities.filter {$0.items.filter {$0.id == self.item?.id}.count > 0}
            } else {
                
            }
            
        })
    }
    
    func addRemoveItemActivity(activity: Activity) {
        if self.itemActivities.contains(activity) {
            self.itemActivities.removeAll {$0.id == activity.id}
        } else {
            self.itemActivities.append(activity)
        }
    }
    
    func updateItemActivities() {
        for activity in self.activities.activities {
            if self.itemActivities.contains(activity) {
                if !activity.items.contains(self.item!) {
                    activity.items.append(self.item!)
                }
            } else {
                activity.items.removeAll {$0 == self.item}
            }
        }
    }
    
    func addNewItemToActivities(newItem: Item) {
        for activity in self.activities.activities {
            if self.itemActivities.contains(activity) {
                activity.items.append(newItem)
            }
        }
    }
}

//struct AddEditItem_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEditItem(showAddEditItemView: false)
//        .environmentObject(Items(fillWithSampleData: true))
//        .environmentObject(Activities())
//    }
//}
