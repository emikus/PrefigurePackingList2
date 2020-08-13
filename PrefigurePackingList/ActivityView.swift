//
//  ActivityView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var activity: Activity
    @Binding var expandedActivityId: UUID
    @EnvironmentObject var activities: Activities
    @EnvironmentObject var items: Items
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "\(activity.symbol)")
                Text(activity.name)
                Spacer()
                Image(systemName: self.activities.selectedActivities.contains(activity) ? "checkmark.circle" : "")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)
            }
            
            if (activity.id == expandedActivityId) {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(activity.items, id: \.id) {activityItem in
                        Text("\(activityItem.name): 𐄷\(activityItem.weight)g ䷰\(activityItem.volume)㎤")
                        .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25.0)
                        
                    }
                }
            }
            
        }
        .foregroundColor(.white)
        .background(Color.black)
        .opacity(0.8)
        .contentShape(Rectangle())
        
        .contextMenu {
            Button(action: {
                self.pinUnpinActivity()
            }) {
                Text(self.activities.activitiesPinned.contains(activity) ? "Unpin this activity" : "Pin to the top")
                Image(systemName: self.activities.activitiesPinned.contains(activity) ? "pin.slash" : "pin")
                    .font(.system(size: 16, weight: .ultraLight))
            }
            
            NavigationLink(destination: AddEditActivityView(activity: self.activity).environmentObject(self.activities).environmentObject(self.items)) {
                Text("Edit \(activity.name)")
                Image(systemName: "square.and.pencil")
            }
            
            Button(action: {
                self.removeActivityFromTheList()
                self.removeActivityItemsFromBag()
            }) {
                Text("Delete from the list")
                Image(systemName: "trash")
                    .font(.system(size: CGFloat(10), weight: .ultraLight))
            }
        }
        .onTapGesture {
            self.expandedActivityId = self.activity.id
            self.updateSelectedActivities()
            
            if self.activities.selectedActivities.contains(self.activity) {
                self.addItemsToBag()
            }
            else {
                self.removeActivityItemsFromBag()
            }
        }
        
    }
    
    func removeActivityItemsFromBag() {
        var selectedActivitiesItems:[Item] = []
        
        //check if other activities in bag share items to be removed
        for selectedActivity in self.activities.selectedActivities {
            
            selectedActivitiesItems += selectedActivity.items
            
        }
        
        
        for item in self.activity.items {
            
            if selectedActivitiesItems.filter({$0 == item}).count == 0 {
                self.items.itemsInBag.removeAll {$0 == item}
            }
        }
    }
    
    func removeActivityFromTheList() {
        self.activities.activities.removeAll {$0.id == self.activity.id}
        self.activities.selectedActivities.removeAll {$0 == self.activity}
    }
    
    func pinUnpinActivity() {
        
        if !self.activities.activitiesPinned.contains(self.activity) {
            self.activities.activitiesPinned.insert(self.activity, at: 0)
            self.activities.activities.removeAll {$0 == self.activity}
        } else {
            self.activities.activitiesPinned.removeAll {$0 == self.activity}
            self.activities.activities.insert(self.activity, at: 0)
        }
    }
    
    func addItemsToBag() {
        for item in self.activity.items {
            if !self.items.itemsInBag.contains(item) {
                self.items.itemsInBag.append(item)
            }
        }
    }
    
    
    
    func updateSelectedActivities() {
        if !self.activities.selectedActivities.contains(self.activity) {
            self.activities.selectedActivities.append(self.activity)
        } else {
            self.activities.selectedActivities.removeAll {$0 == self.activity}
        }
    }
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: Activity(
//        name: "Sport",
//        symbol: "sportscourt",
//        duration: Int.random(in: 10...100),
//        items: [
//            sampleItems[0],
//            sampleItems[1],
//            sampleItems[2]
//            ],
//        category: .general), expandedActivityId: UUID())
//        .environmentObject(Activities())
//        .environmentObject(Items(fillWithSampleData: false))
//    }
//}
