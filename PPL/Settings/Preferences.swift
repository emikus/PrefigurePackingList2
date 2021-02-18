//
//  Preferences.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 03/02/2021.
//

import Foundation
import SwiftUI

struct PreferencesSubview: Identifiable {
    let id = UUID()
    
    let name:String
    let view: AnyView
}

let preferencesSubviews:[PreferencesSubview] = [
    PreferencesSubview(name: "App themes", view: AnyView(ThemesView())),
    PreferencesSubview(name: "Pref 2", view: AnyView(AddEditItem())),
    PreferencesSubview(name: "Pref 3", view: AnyView(AddEditActivityView())),
    PreferencesSubview(name: "New pref name", view: AnyView(AddEditActivityView()))
]


