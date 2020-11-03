//
//  BagView.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct BagView: View {
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
    @State var isDragging = false
    @State var upperPanelHeight = 190.0
    
    var body: some View {
        
        VStack {
            

            ModulesAndShelvesView()
            VolumeWeightDurationIndicatorsView()
            .zIndex(800)
            
            ItemsView()
//            .zIndex(9)
        }
        
        .background(Color.black)
    }
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
