//
//  ItemsView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {
    @EnvironmentObject var items: Items
    @EnvironmentObject var activities: Activities
    @State var showAddEditItemView = false
    
    var body: some View {

            NavigationView {
                VStack {
                    VolumeWeightDurationIndicatorsView()
                    NavigationLink(destination: AddEditItem(showAddEditItemView: self.$showAddEditItemView),isActive : self.$showAddEditItemView) {
                        Image(systemName: "plus")
                        Text("Add new item")
                    }
                    List {
                        Section(header:
                            Text(self.items.itemsPinned.isEmpty ? "Long press the item to add it here" : "Your favourite items")
                                .foregroundColor(.orange)) {
                                    ForEach(self.items.itemsPinned) { item in
                                        ItemView(item: item)
                                        .contextMenu {
                                            Button(action: {
                                                self.pinUnpinItem(item: item)
                                            }) {
                                                Text(self.items.items.contains(item) ? "Pin to the top" : "Unpin this item")
                                                Image(systemName: self.items.items.contains(item) ? "pin" : "pin.slash")
                                                    .font(.system(size: 16, weight: .ultraLight))
                                            }
                                            
                                            NavigationLink(destination: AddEditItem(item: item, showAddEditItemView: self.$showAddEditItemView)) {
                                                Text("Edit \(item.name)")
                                                Image(systemName: "square.and.pencil")
                                            }
                                            
                                            Button(action: {
                                                // enable geolocation
                                                self.removeItemFromTheList(item: item)
                                                self.removeItemFromBag(item: item)
                                                
                                            }) {
                                                Text("Delete from the list")
                                                Image(systemName: "trash")
                                                    .font(.system(size: CGFloat(10), weight: .ultraLight))
                                            }
                                        }
                                    }
                        }
                        Section(header:
                            Text("All your items")
                            .foregroundColor(.orange)) {
                                ForEach(self.items.items) { item in
                                    ItemView(item: item)
                                    .contextMenu {
                                        Button(action: {
                                            self.pinUnpinItem(item: item)
                                        }) {
                                            Text(self.items.items.contains(item) ? "Pin to the top" : "Unpin this item")
                                            Image(systemName: self.items.items.contains(item) ? "pin" : "pin.slash")
                                                .font(.system(size: 16, weight: .ultraLight))
                                        }
                                        
                                        NavigationLink(destination: AddEditItem(item: item, showAddEditItemView: self.$showAddEditItemView)) {
                                            Text("Edit \(item.name)")
                                            Image(systemName: "square.and.pencil")
                                        }
                                        
                                        Button(action: {
                                            // enable geolocation
                                            self.removeItemFromTheList(item: item)
                                            self.removeItemFromBag(item: item)
                                            
                                        }) {
                                            Text("Delete from the list")
                                            Image(systemName: "trash")
                                                .font(.system(size: CGFloat(10), weight: .ultraLight))
                                        }
                                    }
                                }
                                
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Your items")
            }
    }
    
    func removeItemFromBag(item: Item) {
        self.items.itemsInBag.removeAll {$0 == item}
    }
    
    func removeItemFromTheList(item: Item) {
        self.items.items.removeAll {$0 == item}
        self.items.itemsPinned.removeAll {$0 == item}
    }

    func pinUnpinItem(item: Item) {
        if !self.items.itemsPinned.contains(item) {
            self.items.itemsPinned.insert(item, at: 0)
            self.items.items.removeAll {$0 == item}
        } else {
            self.items.itemsPinned.removeAll {$0 == item}
            self.items.items.insert(item, at: 0)
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
            .environmentObject(Activities())
            .environmentObject(Items(fillWithSampleData: true))
    }
}
