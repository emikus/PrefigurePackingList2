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
    @State var alternateIconName:String = ""
    @State var appIconByUser: Bool = false
    
    let layout = [
        GridItem(.adaptive(minimum: 105, maximum: 105))
    ]
    
    
    var body: some View {
        VStack(alignment: .leading) {
//            Icon()
//           Image("dogschildren")
//                .resizable()
//                .scaledToFit()
            
            
            
            ForEach(themes) { theme in
                HStack {
                    Button(action: {
                        
                        selectedThemeColors.changeColorTheme(theme: theme.themeColours)
                        self.themeName = theme.name
                        
                        if (self.appIconByUser == false) {
                            UIApplication.shared.setAlternateIconName(theme.name){ error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            alternateIconName = UIApplication.shared.alternateIconName ?? "nil"
                        }
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
            Divider()
            Toggle(
                "I want to be as unique and special as 95% of my generation and choose the icon myself"
                , isOn: $appIconByUser.animation(.spring()))
            
              
            if (appIconByUser == true) {
                Text("Choose app's icon because your distinctive and special soul and mind really deserve it!!!")
                Text(UIApplication.shared.alternateIconName ?? "nil")
                LazyVGrid(columns: layout, spacing: 5) {
                    ForEach(themes) { theme in
                        Button(action: {
                            UIApplication.shared.setAlternateIconName(theme.name){ error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                alternateIconName = UIApplication.shared.alternateIconName ?? "nil"
                            }
                        }) {
                            
                            Icon(themeColours: theme.themeColours)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(theme.themeColours.fontMainColour, lineWidth: theme.name == alternateIconName
 ? 10 : 0)
                                ).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                
                        }
                    }
                }
                .transition(.slide)
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
