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

    
    var body: some View {
            NavigationView {
                VStack {
                    
                    VolumeWeightDurationIndicatorsView()
                    List {
                        Section(header:
                            Text("Suggested for now".uppercased())
                                
                                .foregroundColor(.orange)) {
                                    ForEach(self.activities.suggestedActivities) { suggestedActivity in
                                    ActivityView(activity: suggestedActivity)
                                        .navigationBarBackButtonHidden(true)
                                }
                                .listRowBackground(Color.black)
                                
                        }
                        
                        ForEach(ActivityCategory.allCases, id: \.self) {category in
                            Section(header:
                                Text(category.rawValue.uppercased())
                                ) {
                                    ForEach(self.activities.activities.filter {$0.category == category}) { suggestedActivity in
                                        ActivityView(activity: suggestedActivity)
                                    }
                                .listRowBackground(Color.black)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                .navigationBarTitle("Activities")
            }
            .navigationViewStyle(StackNavigationViewStyle()) // makes the view cover whole width hiding additional (optional) columns
    }
    
    
}

struct ActivitiesList_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView()
        .environmentObject(Activities())
        .environmentObject(Items(fillWithSampleData: false))
    }
}

