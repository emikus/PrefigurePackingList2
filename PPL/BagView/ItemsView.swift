//
//  ItemsView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI

struct ItemsView: View {
    @State var itemsListVisible:Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                
                Spacer()
                    Button(action: {
                        self.itemsListVisible.toggle()
                    }) {
                        Text(self.itemsListVisible == true ? "Grid view" : "List view")
                    }
            }
            .padding([.top, .trailing],  5.0)
            
            if self.itemsListVisible == true {
                ItemsListView()
            } else {
//                Text("gryd fiu")
                ItemsGridView()
            }
        }
            .padding(.all, 5.0)
        .background(Color.black)
            
            
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
