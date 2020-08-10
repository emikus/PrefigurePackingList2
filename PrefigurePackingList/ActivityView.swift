//
//  ActivityView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var activities: Activities
    @EnvironmentObject var items: Items
    var activity: Activity
    
    var body: some View {
        
        HStack(alignment: .center) {
            Image(systemName: "\(activity.symbol)")
            Text(activity.name)
            Spacer()
            Image(systemName: self.activities.selectedActivities.contains(activity) ? "checkmark.circle" : "")
                .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
            
        }
        .foregroundColor(.white)
        .background(Color.black)
        .opacity(0.8)
        .contentShape(Rectangle())
            .onTapGesture {
                self.updateSelectedActivities(activity: self.activity)
                
                if self.activities.selectedActivities.contains(self.activity) {
                    self.addItemsToBag(items: self.activity.items)
                    
                }
                else {
                    self.removeActivityItemsFromBag(activity: self.activity, items: self.activity.items)
                }
            }
//        .foregroundColor(.black)
        
    }
    
    func addItemsToBag(items: [Item]) {
        for item in items {
            if !self.items.itemsInBag.contains(item) {
                self.items.itemsInBag.append(item)
            }
        }
    }
    
    func removeActivityItemsFromBag(activity: Activity, items: [Item]) {
        var selectedActivitiesItems:[Item] = []
        //check if other activities in bag share items to be removed
        for activity in self.activities.selectedActivities {
            selectedActivitiesItems += activity.items
        }
        
        for item in items {
            if !selectedActivitiesItems.contains(item) {
                self.items.itemsInBag.removeAll {$0 == item}
            }
        }
    }
    
    func updateSelectedActivities(activity: Activity) {
        if !self.activities.selectedActivities.contains(activity) {
            self.activities.selectedActivities.append(activity)
        } else {
            self.activities.selectedActivities.removeAll {$0 == activity}
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(activity: Activity(
        name: "Sport",
        symbol: "sportscourt",
        duration: Int.random(in: 10...100),
        items: [
            sampleItems[0],
            sampleItems[1],
            sampleItems[2]
            ],
        category: .general))
        .environmentObject(Activities())
        .environmentObject(Items(fillWithSampleData: false))
    }
}
