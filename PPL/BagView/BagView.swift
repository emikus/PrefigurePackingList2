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
    
    var body: some View {
        NavigationView {
            Text("Bag sidebar")
            VStack {
                ModulesAndShelvesView()
                VolumeWeightDurationIndicatorsView()
                    .zIndex(800)
                
                
                ItemsView()
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
            .background(Color.black)
            .navigationBarTitle("Pack", displayMode: .inline)
        }
    }
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
