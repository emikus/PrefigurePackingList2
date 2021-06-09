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
        @EnvironmentObject var selectedThemeColors: SelectedThemeColors
        let configuration: Configuration
        var label: some View {
            configuration.label.frame(maxWidth: .infinity).padding([.top, .trailing], 5)
        }
        var body: some View {
            Group {
                if configuration.isPressed {
                    label
                        .foregroundColor(selectedThemeColors.buttonMainColour)
                        .opacity(0.5)
                } else if isEnabled {
                    label
                        .foregroundColor(selectedThemeColors.buttonMainColour)
                        .opacity(1)
                } else {
                    label
                        .foregroundColor(selectedThemeColors.buttonInactiveColour)
                }
            }
        }
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        Content(configuration: configuration)
    }
}

struct KeyboardShortcutsListStyle: ButtonStyle {
    struct Content: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: Configuration
        var label: some View {
            configuration.label
//                .frame(maxWidth: .infinity)
                .padding(5)
        }
        var body: some View {
            Group {
                label
            }
        }
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        Content(configuration: configuration)
    }
}

struct IconsSectionHeader: ViewModifier {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(selectedThemeColors.bgMainColour)
            .padding(5)
            .background(selectedThemeColors.listHeaderColour.opacity(0.9))
            .cornerRadius(5)
    }
}

extension View {
    func iconsSectionHeaderStyle() -> some View {
        self.modifier(IconsSectionHeader())
    }
}
