//
//  Themes.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 25/01/2021.
//

import SwiftUI

struct ThemesView: View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @AppStorage("themeName") var themeName: String?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ForEach(themes) { theme in
                HStack {
                    Button(action: {
                        selectedThemeColors.changeColorTheme(theme: theme.themeColours)
                        self.themeName = theme.name
                    }) {
                        Text(theme.name)
                        .foregroundColor(theme.themeColours.fontMainColour)
                    }
                    .padding(15)
                    .frame(width: 150, alignment: .leading)
                    .background(theme.themeColours.bgSecondaryColour)
                    .cornerRadius(10)
                    theme.themeColours.bgMainColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(5)
                    theme.themeColours.bgSecondaryColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(10)
                    theme.themeColours.buttonBgColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(5)
                    theme.themeColours.buttonInactiveBgColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(10)
                    theme.themeColours.buttonInactiveColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(5)
                    theme.themeColours.elementActiveColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(10)
                    theme.themeColours.fontMainColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(5)
                    theme.themeColours.fontSecondaryColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(10)
                    theme.themeColours.listHeaderColour
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(5)
                }
            }
            
            
            
            
            
            
        }
    }
}

struct Themes_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
        .environmentObject(SelectedThemeColors())
    }
}
