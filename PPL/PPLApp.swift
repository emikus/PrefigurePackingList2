//
//  PPLApp.swift
//  PPL
//
//  Created by Macbook Pro on 08/10/2020.
//

import SwiftUI

@main
struct PPLApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
