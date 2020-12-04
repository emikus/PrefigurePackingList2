//
//  PlanView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct PlanView: View {
    
    
    
    var body: some View {
        NavigationView {
            Text("Plan sidebar")
            VStack {
                PanelsView()
                VolumeWeightDurationIndicatorsView()
                    .zIndex(10000.00)
                ActivitiesListView()
                
            }
            .navigationBarTitle("Plan", displayMode: .inline)
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
