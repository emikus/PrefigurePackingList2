//
//  Themes.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 25/01/2021.
//

import SwiftUI

struct ThemesView: View {
    @AppStorage("themeName") var themeName: String?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Button(action: {
                self.themeName = themes[0].name
                changeColorTheme(theme: themes[0].themeColours)
            }) {
                Text(themes[0].name)
                    .foregroundColor(themes[0].themeColours.fontMainColour)
            }
            .padding(15)
            .frame(width: 140, alignment: .leading)
            .background(themes[0].themeColours.bgSecondaryColour)
            .cornerRadius(10)
//            Text(a)
            
            Button(action: {
                self.themeName = themes[1].name
                changeColorTheme(theme: themes[1].themeColours)
            }) {
                Text(themes[1].name)
                    .foregroundColor(themes[1].themeColours.fontMainColour)
            }
            .padding(15)
            .frame(width: 140, alignment: .leading)
            .foregroundColor(fontMainColour)
            .background(themes[1].themeColours.bgSecondaryColour)
            .cornerRadius(10)
            
            Button(action: {
                self.themeName = themes[2].name
                changeColorTheme(theme: themes[2].themeColours)
            }) {
                Text(themes[2].name)
                    .foregroundColor(themes[2].themeColours.fontSecondaryColour)
            }
            .padding(15)
            .frame(width: 140, alignment: .leading)
            .foregroundColor(fontMainColour)
            .background(themes[2].themeColours.bgSecondaryColour)
            .cornerRadius(10)
            
            
        }
    }
}

struct Themes_Previews: PreviewProvider {
    static var previews: some View {
        ThemesView()
    }
}
