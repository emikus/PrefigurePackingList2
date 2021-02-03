//
//  ItemToBuyGridView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 18/09/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ItemToBuyGridView: View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
    var body: some View {
            VStack(alignment: .leading) {
                    Text("🪓")
                    Spacer()
                    Text("One of the best items in the world...")
                        .font(.caption)
                    Spacer()
                    Text("             $ 49.99")
                        .font(.caption)
            }
            .foregroundColor(selectedThemeColors.fontSecondaryColour)
            .opacity(0.5)
            .frame(width: 100, height: 100)
            .padding([.top,.bottom], 10.0)
            .background(selectedThemeColors.fontMainColour.opacity(0.2))
            .cornerRadius(10)
            .contentShape(Rectangle())
        }
        
    }

    


//struct ItemToBuyGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemToBuyGridView(item: sampleItems[0])
//    }
//}
