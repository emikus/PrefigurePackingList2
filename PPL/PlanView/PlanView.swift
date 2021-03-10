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
    
    
    var body: some View {
        NavigationView {
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
