//
//  ActivitiesList.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ActivitiesListView: View {
    @EnvironmentObject var activities: Activities
    @EnvironmentObject var items: Items
    @State private var expandedActivityId: UUID = UUID()

    
    var body: some View {
            NavigationView {
                VStack {
                    
                    VolumeWeightDurationIndicatorsView()
                    
                    NavigationLink(destination: AddEditActivityView().environmentObject(self.activities).environmentObject(self.items)) {
                        Image(systemName: "plus")
                        Text("Add new activity")
                    }
                    List {
                        Section(header:
                            Text("Suggested for now".uppercased())
                                
                                .foregroundColor(.orange)) {
                                    ForEach(self.activities.activitiesPinned) { suggestedActivity in
                                        ActivityView(activity: suggestedActivity, expandedActivityId: self.$expandedActivityId)
                                        .navigationBarBackButtonHidden(true)
                                            .animation(.easeInOut(duration: 0.5))
                                }
                                .listRowBackground(Color.black)
                                
                        }
                        
                        ForEach(ActivityCategory.allCases, id: \.self) {category in
                            Section(header:
                                Text(category.rawValue.uppercased())
                                ) {
                                    ForEach(self.activities.activities.filter {$0.category == category}) { activity in
                                        ActivityView(activity: activity, expandedActivityId: self.$expandedActivityId)
                                            .animation(.linear(duration: 0.5))
                                    }
                                .listRowBackground(Color.black)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .animation(.linear(duration: 0.3))
                }
                .navigationBarTitle("Activities")
            }
//            .navigationViewStyle(StackNavigationViewStyle()) // makes the view cover whole width hiding additional (optional) columns
    }
    
    
}

struct ActivitiesList_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView()
        .environmentObject(Activities())
        .environmentObject(Items(fillWithSampleData: false))
    }
}

