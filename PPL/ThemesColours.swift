//
//  ThemesColours.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 26/01/2021.
//

import Foundation
import SwiftUI

//var bgMainColour: Color = Color.black
//var bgSecondaryColour: Color = Color(red: 28/255, green: 29/255, blue: 31/255)
//var fontMainColour: Color = Color.white
//var fontSecondaryColour: Color = Color.gray
//var elementActiveColour: Color = Color.green
//var buttonMainColour: Color = Color.blue
//var buttonBgColour: Color = Color.green
//var buttonInactiveColour: Color = Color.gray
//var buttonInactiveBgColour: Color = Color.green.opacity(0.5)
//var listHeaderColour: Color = Color.orange
var alertColour: Color = Color.red

var bgMainColour = Color.white
var bgSecondaryColour = Color(red: 227/255, green: 226/255, blue: 224/255)
var fontMainColour = Color(red: 30/255, green: 30/255, blue: 30/255)
var fontSecondaryColour = Color.gray
var elementActiveColour = Color.green
var buttonMainColour = Color.blue
var buttonBgColour = Color.green
var buttonInactiveColour = Color.gray
var buttonInactiveBgColour = Color.green.opacity(0.5)
var listHeaderColour = Color.orange


//var bgMainColour: Color = .black
//var bgMainColour: Color = .black


let themes: Array = [
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
    )
]




struct Theme: Hashable {
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.name > rhs.name
    }
    
    let name: String
    let themeColours: ThemeColours
}


struct ThemeColours: Hashable {
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


func changeColorTheme(theme: ThemeColours) -> Void {
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
