//
//  VolumeWeightDurationIndicators.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct VolumeWeightDurationIndicatorsView: View {
    @EnvironmentObject var items: Items
    
    var body: some View {
      
            HStack {
                Text("𐄷: \(self.items.itemsInBagWeight)")
                Text("䷰: \(self.items.itemsInBagVolume)")
                Text("⏳: toBeSetLater")
            }
            .font(.footnote)
            .padding()
        .onAppear(perform: {
            print("///////////",self.items.itemsInBag, "///////////")})
        
        
    }
}

