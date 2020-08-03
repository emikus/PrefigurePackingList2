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
            NavigationView {
                VStack {
                    
                    VolumeWeightDurationIndicatorsView()
                    List {
                        Section(header:
                            Text("Add items to your bag")
                                .foregroundColor(.orange)) {
                                    ForEach(items.items) { item in
                                        ItemView(item: item)
                                }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .navigationBarTitle("Items")
            }
        }
    }
}

//struct ItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemsView()
//    }
//}
