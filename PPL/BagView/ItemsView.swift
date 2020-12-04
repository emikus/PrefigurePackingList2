//
//  ItemsView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI

struct ItemsView: View {
    @State var itemsListVisible:Bool = false
    @State var searchBarVisible:Bool = false
    @State var startPos : CGPoint = .zero
   @State var isSwipping = true
    
    var body: some View {
        VStack {
            if self.itemsListVisible == true {
                ItemsListView(itemsListVisible: $itemsListVisible)
            } else {
                ItemsGridView(itemsListVisible: $itemsListVisible)
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
