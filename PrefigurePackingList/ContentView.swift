//
//  ContentView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @ObservedObject var items = Items(fillWithSampleData: true)
    
    
    
    var body: some View {
       GeometryReader { geo in
        TabView {
            ActivitiesListView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Activities for now")
                }
            
            ItemsListView()
                .tabItem {
                    Image(systemName: "umbrella")
                    Text("Items")
                }
            
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(self.activities)
        .environmentObject(self.items)
        .padding(.leading, UIDevice.current.userInterfaceIdiom == .pad && geo.size.height > geo.size.width ? 1 : 0) // hack to make first column visible in portrait and landscape orientation on iPad
        }
        
        
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
