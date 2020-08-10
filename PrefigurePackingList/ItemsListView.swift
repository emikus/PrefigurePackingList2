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
    
    var body: some View {
        
        Group {
//             GeometryReader { geo in
            NavigationView {
                VStack {
                    
                    VolumeWeightDurationIndicatorsView()
                    NavigationLink(destination: AddEditItem()) {
                        Image(systemName: "plus")
                        Text("Add new item")
                    }
                    List {
                        Section(header:
                            Text(self.items.itemsPinned.isEmpty ? "Long press the item to add it here" : "Your favourite items")
                                .foregroundColor(.orange)) {
                                    ForEach(self.items.itemsPinned) { item in
                                        ItemView(item: item)
                                    }
                        }
                        Section(header:
                            Text("All your items")
                                .foregroundColor(.orange)) {
                                    ForEach(self.items.items) { item in
                                        ItemView(item: item)
                                    }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Your items")
//            }
//                .padding(.leading, geo.size.height > geo.size.width ? 1 : 0)
                
            }
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
