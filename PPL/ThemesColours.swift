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
            fontMainColour: Color.purple,
            fontSecondaryColour: Color.purple,
            elementActiveColour: Color.yellow,
            buttonMainColour: Color.blue,
            buttonBgColour: Color.green,
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color.green.opacity(0.5),
            listHeaderColour: Color.pink)
    ),
    Theme(
        name: "Calm 预言",
        themeColours: ThemeColours(
            bgMainColour: Color(hex: "#aca69f"),
            bgSecondaryColour: Color(hex: "#dcdfe4"),
            fontMainColour: Color(hex: "#0f211a"),
            fontSecondaryColour: Color(hex: "#666b3a"),
            elementActiveColour: Color.green,
            buttonMainColour: Color(hex: "#adab76"),
            buttonBgColour: Color(hex: "#fd9a7e"),
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color(hex: "#dc6d02"),
            listHeaderColour: Color(hex: "#dc6d02")
        )
    ),
    Theme(
        name: "Monias choice",
        themeColours: ThemeColours(
            bgMainColour: Color(hex: "#ada49f"),
            bgSecondaryColour: Color(hex: "#ff00cc"),
            fontMainColour: Color(hex: "#0f4476"),
            fontSecondaryColour: Color(hex: "#666b3a"),
            elementActiveColour: Color.green,
            buttonMainColour: Color(hex: "#adab76"),
            buttonBgColour: Color(hex: "#fd9a7e"),
            buttonInactiveColour: Color.gray,
            buttonInactiveBgColour: Color(hex: "#dc6d02"),
            listHeaderColour: Color(hex: "#dc6d02")
        )
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
            listHeaderColour: getRandomColor()
        )
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

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}





