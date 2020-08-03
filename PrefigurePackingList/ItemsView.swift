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
    
    
    var body: some View {
      
        Group {
            NavigationView {
                VStack {
                    
                    VolumeWeightDurationIndicatorsView()
                    List {
                        Section(header:
                            Text("Suggested for now")
                                .foregroundColor(.orange)) {
                                    ForEach(items.items) { item in
                                    
                                        
                                        ItemView(item: item)
                                    
                                    
                                        
                                }
                                
                                
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .navigationBarTitle("Items")
                .onAppear(perform: {
                    print("+++++++++",self.items.itemsInBag, "+++++++++")})
            }
        }
        
        
    }
}

//struct ItemsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemsView()
//    }
//}
