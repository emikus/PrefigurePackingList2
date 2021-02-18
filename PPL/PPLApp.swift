//
//  PPLApp.swift
//  PPL
//
//  Created by Macbook Pro on 08/10/2020.
//

import SwiftUI

@main
struct PPLApp: App {
    
    @AppStorage("themeName") var themeName: String = "Dark mode"
    @ObservedObject var selectedThemeColors = SelectedThemeColors()
    @ObservedObject var iconSettings = IconNames()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    print("dupa blada!!!", themeName)
                    selectedThemeColors.changeColorTheme(theme: themes.first(where: {$0.name == themeName})!.themeColours)
                }
                .colorScheme(themeName == "Light mode" ? .light : .dark)
                .environment(\.colorScheme, themeName == "Light mode" ? .light : .dark)
                // .preferredColorScheme(.light)
                .environmentObject(self.selectedThemeColors)
                .environmentObject(self.iconSettings)
        }
        
    }
}

struct AppCommands: Commands {

    func next() {}
    func prev() {}

    @CommandsBuilder var body: some Commands {
        CommandMenu("Navigation") {
            Button(action: {
                next()
            }) {
                Text("Next")
            }

            Button(action: {
                prev()
            }) {
                Text("Previous")
            }
        }
    }
}
