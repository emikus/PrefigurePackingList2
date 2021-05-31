//
//  PlanView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct PlanView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State var scrollToCategoryName:String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    @State var selectedTag: Any = "Dupa"
    
    private func deleteTags(offsets: IndexSet) {
            withAnimation {
                offsets.map { tags[$0] }.forEach(viewContext.delete)

                do {
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tags list")) {
                    ForEach (tags, id: \.id) {tag in
                        HStack {
                            TagView(tag: tag)
                                .onTapGesture {
                                    withAnimation {
                                        selectedTag = tag
                                    }
                                }
                                
                            Spacer()
                            
                            Button(action: {
                                viewContext.delete(tag)
                                try? viewContext.save()
                            }, label: {
                                Image(systemName: ("trash"))
                                    .foregroundColor(selectedThemeColors.buttonMainColour)
                                    .padding(.trailing, 5)
                            })
                        }
                    }
                    .onDelete(perform: deleteTags)
                }
            }
            .listStyle(SidebarListStyle())
            VStack {
                if (type(of: selectedTag) == Tag.self) {
                    HStack {
                        Text(((selectedTag as AnyObject).name!.lowercased()))
                            .foregroundColor(selectedThemeColors.listHeaderColour)
                            .padding()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                selectedTag = "dupa"
                            }
                        }, label: {
                            Image(systemName: ("xmark"))
                                .padding(.trailing, 10)
                        })
                    }
                    .listRowInsets(EdgeInsets(
                                    top: 0,
                                    leading: 0,
                                    bottom: 0,
                                    trailing: 0))
                    List {
                        ForEach((selectedTag as! Tag).activityArray, id: \.self) {activity in
                            Text(activity.name!)
                        }
                    }
                }
                
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
                                    withAnimation {
                                    scrollToCategoryName = category
                                    }
                                }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .transition(.slide)
            
            VStack {
                PanelsView()
                VolumeWeightDurationIndicatorsView()
                    .zIndex(10000.00)
                ActivitiesListView(scrollToCategoryName: $scrollToCategoryName)
                
            }
            .navigationBarTitle("Plan", displayMode: .inline)
        }
        
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
