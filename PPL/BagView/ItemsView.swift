//
//  ItemsView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI

struct ItemsView: View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @AppStorage("itemsViewType") var itemsViewType: String = "grid"
    @State var itemsListVisible:Bool = false
    @State var searchBarVisible:Bool = false
    @State var startPos : CGPoint = .zero
    @State var isSwipping = true
    @Binding var scrollToCategoryName: String
    
    var body: some View {
        VStack {
            if self.itemsViewType == "list" {
                ItemsListView()
            } else {
                ItemsGridView(scrollToCategoryName: $scrollToCategoryName)
            }
        }
        .padding(.all, 5.0)
        .background(selectedThemeColors.bgMainColour)
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(scrollToCategoryName: .constant(""))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
