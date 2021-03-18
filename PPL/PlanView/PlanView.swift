//
//  PlanView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State var scrollToCategoryName:String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Tags list")) {
                        ForEach (tags, id: \.id) {tag in
                            VStack {
                                Text(tag.wrappedName)
                                ForEach (tag.activityArray, id: \.id) {activity in
                                    Text(activity.wrappedName)
                                        .padding(.leading, 30)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                
                List {
                    Section(header: HStack {
                        Text("Scroll to:")
                            .foregroundColor(selectedThemeColors.listHeaderColour)
                            .padding()
                        
                        
                        Spacer()
                    }
                    .listRowInsets(EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0))) {
                        ForEach(activitiesCategories, id: \.self) {category in
                            Text(category.uppercased())
                                .onTapGesture {
                                    scrollToCategoryName = category
                                }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            
            VStack {
                PanelsView()
                VolumeWeightDurationIndicatorsView()
                    .zIndex(10000.00)
                ActivitiesListView(scrollToCategoryName: $scrollToCategoryName)
                
            }
//             .preferredColorScheme(.dark)
//            .onAppear(perform: {
//                changeColorTheme(theme: themes[0].themeColours)
//            })
            .navigationBarTitle("Plan", displayMode: .inline)
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
