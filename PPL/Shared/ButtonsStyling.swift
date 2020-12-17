//
//  ButtonsStyling.swift
//  PPL
//
//  Created by Macbook Pro on 02/12/2020.
//

import SwiftUI

//struct MainButtonStyle: ButtonStyle {
//
//    public func makeBody(configuration: MainButtonStyle.Configuration) -> some View {
//        MainButton(configuration: configuration)
//    }
//
//    struct MainButton: View {
//        let configuration: MainButtonStyle.Configuration
//
//        var body: some View {
//
//            return configuration.label
//                .foregroundColor(.blue)
//                .padding([.top, .trailing], 5)
//                .opacity(configuration.isPressed ? 0.5 : 1.0)
//        }
//    }
//
//}

struct MainButtonStyle: ButtonStyle {
    struct Content: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: Configuration
        var label: some View {
            configuration.label.frame(maxWidth: .infinity).padding([.top, .trailing], 5)
        }
        var body: some View {
            Group {
                if configuration.isPressed {
                    label
                        .foregroundColor(Color.blue)
                        .opacity(0.5)
                } else if isEnabled {
                    label
                        .foregroundColor(Color.blue)
                        .opacity(1)
                } else {
                    label
                        .foregroundColor(Color.gray)
                        .opacity(0.5)
                }
            }
        }
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        Content(configuration: configuration)
    }
}
