//
//  BagView.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct BagView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var modules: Modules
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BagContentSet.date, ascending: false)],
        animation: .default)
    private var bagContentSets: FetchedResults<BagContentSet>
    
    @State var isDragging = false
    @State var upperPanelHeight = 190.0
    @State var showAddEditItem = false
    @State var showAddBagContentSet = false
    @State var showBagContentSets = false
    @State var showKeyboardShortcutsView = false
    @State var scrollToCategoryName:String = ""
    @State var itemsCategories: [String] = []
    
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
                    ForEach(itemsCategories, id: \.self) {itemCategory in
                            Text(itemCategory.uppercased())
                                .onTapGesture {
                                    scrollToCategoryName = itemCategory
                                }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            
            
//            VStack {
//            Text("Bag sidebar")
//            Button(action: {
//                scrollToCategoryName = "food"
//            }) {
//                Text("DUPA!!!")
//            }
//
//                Button(action: {
//                    scrollToCategoryName = "clothes"
//                }) {
//                    Text("DUPA!!!")
//                }
//
//                Button(action: {
//                    scrollToCategoryName = "electrical"
//                }) {
//                    Text("DUPA!!!")
//                }
//            }
            VStack {
                ModulesAndShelvesView()
                VolumeWeightDurationIndicatorsView()
                    .zIndex(800)
                
                
                ItemsView(scrollToCategoryName: $scrollToCategoryName)
                Button(action: {
                    self.showKeyboardShortcutsView = true
                }){
                        Text("Keyboard shortcuts")
                            .font(.system(size: 0))
                        
                    }
                .keyboardShortcut(KeyEquivalent(","))
                .sheet(isPresented: self.$showKeyboardShortcutsView) {
                    KeyboardShortcutsView()
                }
                .opacity(0)
            }
            .background(selectedThemeColors.bgMainColour)
            .navigationBarTitle("Pack", displayMode: .inline)
            .onChange(of: scrollToCategoryName) { newValue in
                            print("BAG VIEW Name changed to \(scrollToCategoryName)!")
                        }
        }
        .onAppear{
            let itemsCategories = self.items.compactMap { $0.itemCategory }
            print (Set(itemsCategories))
            self.itemsCategories = Array(Set(itemsCategories)).sorted {$0 < $1}
        }
    }
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
    }
}
