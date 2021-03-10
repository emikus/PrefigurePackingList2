//
//  ActivitiesListView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct ActivitiesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    //debug only
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    //debug only END
    @State private var expandedActivityId: UUID = UUID()
    @State var showAddEditActivityView = false
    @Binding var scrollToCategoryName: String
    
    func getActivitiesDuration () -> Int {
        var allActivitiesDuration = 0
        for activity in self.activities.filter({$0.isSelected==true}) {
            allActivitiesDuration += Int(activity.duration)
        }
        return allActivitiesDuration
    }
    
    func itemsInBagVolume () -> Int {
        var itemsInBagVolume = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagVolume += Int(item.volume)
        }
        
        
        return itemsInBagVolume
    }
    
//    .co

    var body: some View {
            HStack {
                VStack {

                    
                    Button(action: {
                        self.showAddEditActivityView.toggle()
                    }) {
                        Text("Add activity")
                    }
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
                    ScrollViewReader { scrollView in
                        List {
                            //                        Section(header:
                            //                            Text("Favourite activities".uppercased())
                            //
                            //                                .foregroundColor(.orange)) {
                            //                                    ForEach(self.activities.activitiesPinned) { suggestedActivity in
                            //                                        ActivityView(activity: suggestedActivity, expandedActivityId: self.$expandedActivityId)
                            //                                        .navigationBarBackButtonHidden(true)
                            //                                            .animation(.easeInOut(duration: 0.5))
                            //                                }
                            //                                .listRowBackground(Color.black)
                            //
                            //                        }
                            
                            //                        Section(header: HStack{
                            //                                    Text(self.items.filter({$0.isPinned == true}).count == 0 ? "Long press the item to add it here" : "Your favourite items")
                            //                                .foregroundColor(listHeaderColour)
                            //                                .padding()
                            //
                            //                                Spacer()
                            //                        }
                            //                        .background(bgMainColour)
                            //                        .listRowInsets(EdgeInsets(
                            //                                top: 0,
                            //                                leading: 0,
                            //                                bottom: 0,
                            //                                trailing: 0))) {
                            
                            
                            
                            
                            ForEach(activitiesCategories, id: \.self) {category in
                                Section(header: HStack {
                                    Text(category.uppercased())
                                        .foregroundColor(selectedThemeColors.listHeaderColour)
                                        .padding()
                                    
                                    Spacer()
                                }
                                .background(selectedThemeColors.bgMainColour)
                                .listRowInsets(EdgeInsets(
                                                top: 0,
                                                leading: 0,
                                                bottom: 0,
                                                trailing: 0))
                                .id(category)
                                ) {
                                    ForEach(self.activities.filter {$0.category == category}) { activity in
                                        ActivityView(activity: activity, expandedActivityId: self.$expandedActivityId)
                                            .animation(.linear(duration: 0.5))
                                    }
                                    .listRowBackground(selectedThemeColors.bgMainColour)
                                }
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .animation(.linear(duration: 0.3))
                        .onChange(of: scrollToCategoryName) { newValue in
                            print("ActivitiesListView: Name changed to \(scrollToCategoryName)!")
                            withAnimation{
                                scrollView.scrollTo(scrollToCategoryName, anchor: .top)
                            }
                        }
                    }
                }
                .sheet(isPresented: self.$showAddEditActivityView) {
                    AddEditActivityView()
                        .environment(\.managedObjectContext, self.viewContext)
                        .environmentObject(self.selectedThemeColors)
                                
                }
            }
            .onAppear {
                self.getActivitiesDuration()
                self.itemsInBagVolume()
            }
    
    }
    
    
}

struct ActivitiesList_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView(scrollToCategoryName: .constant(""))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
        
    }
}
