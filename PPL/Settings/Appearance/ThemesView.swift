//
//  Themes.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 25/01/2021.
//

import SwiftUI

struct ThemesView:  View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @EnvironmentObject var iconSettings: IconNames
    @AppStorage("themeName") var themeName: String?
    
    
    var body: some View {
        VStack(alignment: .leading) {
//            Icon()
            Image("dogschildren")
                .resizable()
                .scaledToFit()
            ForEach(themes) { theme in
                HStack {
                    Button(action: {
//                        print(self.iconSettings.iconNames)
//                        print(self.iconSettings.iconNames[1], "dogschildren")
//                        generateAppIcon()
                        let index = (themes.firstIndex(where: {$0.name == theme.name})! % 2 == 0) ? 0 : 1
                        UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[index]){ error in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        } else {
                                                            print("Success!")
                                                        }
                                                    }
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
