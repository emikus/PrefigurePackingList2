//
//  BuyItemsGridView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 18/09/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct BuyItemsGridView: View {
    @State var showAddEditItemView: Bool = false
    
    var body: some View {
        Image(systemName: "plus")
            .font(.system(size: 70, weight: .bold, design: .monospaced))
            
            .opacity(0.5)
            .frame(width: 100, height: 100)
            .padding([.top,.bottom], 10.0)
            .background(Color(red: 51/255, green: 51/255, blue: 51/255))
            .cornerRadius(10)
            .contentShape(Rectangle())
            .onTapGesture {
                self.showAddEditItemView.toggle()
            }
        .sheet(isPresented: self.$showAddEditItemView) {
            AddEditItem()
        }
    }
}

struct BuyItemsGridView_Previews: PreviewProvider {
    static var previews: some View {
        BuyItemsGridView()
    }
}