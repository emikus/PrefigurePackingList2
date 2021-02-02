//
//  ActivitiesListView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct ActivitiesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
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
    
    init() {
        UITableView.appearance().separatorColor = .clear
    }

    var body: some View {
            HStack {
                VStack {

                    
                    Button(action: {
                        self.showAddEditActivityView.toggle()
                    }) {
                        Text("Add activity")
                    }
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)

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
                                .foregroundColor(listHeaderColour)
                                .padding()
                                
                                Spacer()
                            }
                            .background(bgMainColour)
                            .listRowInsets(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 0))
                                ) {
                                    ForEach(self.activities.filter {$0.category == category}) { activity in
                                        ActivityView(activity: activity, expandedActivityId: self.$expandedActivityId)
                                            .animation(.linear(duration: 0.5))
                                    }
                                .listRowBackground(bgMainColour)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .animation(.linear(duration: 0.3))
                }
                .sheet(isPresented: self.$showAddEditActivityView) {
                    AddEditActivityView()
                        .environment(\.managedObjectContext, self.viewContext)
                                
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
        ActivitiesListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
    }
}
