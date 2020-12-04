//
//  ButtonsStyling.swift
//  PPL
//
//  Created by Macbook Pro on 02/12/2020.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: MainButtonStyle.Configuration) -> some View {
        MainButton(configuration: configuration)
    }
    
    struct MainButton: View {
        let configuration: MainButtonStyle.Configuration
        
        var body: some View {
            
            return configuration.label
                .foregroundColor(.blue)
                .padding([.top, .trailing], 5)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
        }
    }

}
