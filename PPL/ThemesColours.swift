//
//  ThemesColours.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 26/01/2021.
//

import Foundation
import SwiftUI

class SelectedThemeColors: ObservableObject {
    @Published var bgMainColour = Color.white
    @Published var bgSecondaryColour = Color(red: 227/255, green: 226/255, blue: 224/255)
    @Published var fontMainColour = Color(red: 30/255, green: 30/255, blue: 30/255)
    @Published var fontSecondaryColour = Color.gray
    @Published var elementActiveColour = Color.green
    @Published var buttonMainColour = Color.blue
    @Published var buttonBgColour = Color.green
    @Published var buttonInactiveColour = Color.gray
    @Published var buttonInactiveBgColour = Color.green.opacity(0.5)
    @Published var listHeaderColour = Color.orange
    
    func changeColorTheme(theme: ThemeColours) -> Void {
        print("dupa")
        themes.forEach {theme in
            print(theme.name)
        }
        bgMainColour = theme.bgMainColour
        bgSecondaryColour = theme.bgSecondaryColour
        fontMainColour = theme.fontMainColour
        fontSecondaryColour = theme.fontSecondaryColour
        elementActiveColour = theme.elementActiveColour
        buttonMainColour = theme.buttonMainColour
        buttonBgColour = theme.buttonBgColour
        buttonInactiveColour = theme.buttonInactiveColour
        buttonInactiveBgColour = theme.buttonInactiveBgColour
        listHeaderColour = theme.listHeaderColour
    }
}

let themes: [Theme] = [
    Theme(
        name: "Dark mode",
        themeColours: ThemeColours(
            bgMainColour: Color.black,
            bgSecondaryColour: Color(red: 28/255, green: 29/255, blue: 31/255),
            fontMainColour: Color.white,
            fontSecondaryColour: Color.gray,
            elementActiveColour: Color.green,
            buttonMainColour: Color.blue,
            buttonBgColour: Color.green,
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color.green.opacity(0.5),
            listHeaderColour: Color.orange)
    ),
    Theme(
        name: "Light mode",
        themeColours: ThemeColours(
            bgMainColour: Color(red: 242/255, green: 242/255, blue: 247/255),
            bgSecondaryColour: Color.white,
            fontMainColour: Color(red: 30/255, green: 30/255, blue: 30/255),
            fontSecondaryColour: Color.gray,
            elementActiveColour: Color.green,
            buttonMainColour: Color.blue,
            buttonBgColour: Color.green,
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color.green.opacity(0.5),
            listHeaderColour: Color.orange)
    ),
    Theme(
        name: "Disco mode",
        themeColours: ThemeColours(
            bgMainColour: Color.orange,
            bgSecondaryColour: Color.red,
            fontMainColour: Color.pink,
            fontSecondaryColour: Color.purple,
            elementActiveColour: Color.yellow,
            buttonMainColour: Color.blue,
            buttonBgColour: Color.green,
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color.green.opacity(0.5),
            listHeaderColour: Color.purple)
    ),
    Theme(
        name: "Random colors",
        themeColours: ThemeColours(
            bgMainColour: getRandomColor(),
            bgSecondaryColour: getRandomColor(),
            fontMainColour: getRandomColor(),
            fontSecondaryColour: getRandomColor(),
            elementActiveColour: getRandomColor(),
            buttonMainColour: getRandomColor(),
            buttonBgColour: getRandomColor(),
            buttonInactiveColour: getRandomColor(),
            buttonInactiveBgColour: getRandomColor(),
            listHeaderColour: getRandomColor())
    )
]

func getRandomColor() -> Color {
     //Generate between 0 to 1
    let red:Double = .random(in: 0...255)/255
     let green:Double = .random(in: 0...255)/255
     let blue:Double = .random(in: 0...255)/255
    
    let generatedColor = Color(red: red, green: green, blue: blue)
     return generatedColor
}




struct Theme: Identifiable {
    let id = UUID()
    let name: String
    let themeColours: ThemeColours
}


struct ThemeColours {
    let bgMainColour: Color
    let bgSecondaryColour: Color
    let fontMainColour: Color
    let fontSecondaryColour: Color
    let elementActiveColour: Color
    let buttonMainColour: Color
    let buttonBgColour: Color
    let buttonInactiveColour: Color
    let buttonInactiveBgColour: Color
    let listHeaderColour: Color
}
