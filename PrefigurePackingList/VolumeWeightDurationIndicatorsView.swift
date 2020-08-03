//
//  VolumeWeightDurationIndicators.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 30/07/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct VolumeWeightDurationIndicatorsView: View {
    @EnvironmentObject var activities: Activities
    @EnvironmentObject var items: Items
    private let viewHeight: CGFloat = 30
    
    var body: some View {
      GeometryReader { geometry in
            HStack {
                HStack{
                    Text("𐄷")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("\(self.items.itemsInBagWeight)g")
                }
                .frame(width: geometry.size.width / 3, height: self.viewHeight)
                
                HStack{
                    Text("䷰")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                    Text("\(self.items.itemsInBagVolume)㎤")
                }
                .frame(width: geometry.size.width / 3, height: self.viewHeight)
                
                HStack{
                    Image(systemName:"clock")
                        .foregroundColor(.green)
                    Text("\(self.activities.selectedActivitiesDuration) '")
                }
                .frame(width: geometry.size.width / 3, height: self.viewHeight)
                
                
            }
            .opacity(0.7)
            .background(Color.yellow)
            .foregroundColor(.blue)
            .font(.footnote)
            .padding()
        }
      .background(Color.green)
      .frame(height: 50)
        
        
        
    }
}


struct VolumeWeightDurationIndicatorsView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeWeightDurationIndicatorsView()
        .environmentObject(Activities())
        .environmentObject(Items(fillWithSampleData: false))
    }
}

