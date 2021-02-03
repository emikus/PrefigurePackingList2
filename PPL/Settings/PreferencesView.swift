//
//  SettingsView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 23/01/2021.
//

import SwiftUI

//var a:String = "a"

struct PreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @AppStorage("themeName") var themeName: String?
    
    @State var selectedViewName = "App themes"
    var viewsNames:[String] = [
        "App themes",
        "Sample preferences view",
        "Sample preferences view 2"
    ]
    
    
    func selectNextView() {
        let selectedViewIndex:Int = preferencesSubviews.firstIndex(where: { $0.name == self.selectedViewName})!
        let isLastItemSelected:Bool = selectedViewIndex + 1 == preferencesSubviews.count ? true : false
        
        if isLastItemSelected == true {
            self.selectedViewName = preferencesSubviews[0].name
        } else {
            self.selectedViewName = preferencesSubviews[selectedViewIndex + 1].name
        }
    }
    
    func selectPreviousView() {
        let selectedViewIndex:Int = preferencesSubviews.firstIndex(where: { $0.name == self.selectedViewName})!
        let isFirstItemSelected:Bool = selectedViewIndex == 0 ? true : false
        
        if isFirstItemSelected == true {
            self.selectedViewName = preferencesSubviews[self.viewsNames.count - 1].name
        } else {
            self.selectedViewName = preferencesSubviews[selectedViewIndex - 1].name
        }
    }
    
    var body: some View {
//        VStack {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading) {
                    
                    
                    ForEach(preferencesSubviews) { subview in
                        Button(action: {
                            self.selectedViewName = subview.name
                        }) {
                            Text(subview.name)
                                .foregroundColor(selectedThemeColors.fontMainColour)
                        
                        }
                        .buttonStyle(KeyboardShortcutsListStyle())
                        .frame(width: geometry.size.width / 5, height: 34, alignment: .leading)
                        .background(self.selectedViewName == subview.name ? selectedThemeColors.fontSecondaryColour : selectedThemeColors.fontSecondaryColour.opacity(0))
                        .cornerRadius(3)
                    }
                    
                    Divider()
                    HStack {
                    Text("Next")
                        .font(.footnote)
                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        Spacer()
                        Text("⌥ ⌘ N")
                            .padding(4)
                             .background(selectedThemeColors.fontSecondaryColour.opacity(0.5))
                            .cornerRadius(3)
                            
                    }
                    .font(.footnote)
                    
                    HStack {
                    Text("Previous")
                        .font(.footnote)
                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        Spacer()
                        Text("⌥ ⌘ P")
                            .padding(4)
                            .background(selectedThemeColors.fontSecondaryColour.opacity(0.5))
                            .cornerRadius(3)
                            
                            
                    }
                    .font(.footnote)
                    .padding(.top, 1)
                    
                    Button(action: {
                        self.selectNextView()
                    }) {
                        Text("next view")
                    }
                    .opacity(0)
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: [.command, .option])
                    
                    Button(action: {
                        self.selectPreviousView()
                    }) {
                        Text("previous view")
                    }
                    .opacity(0)
                    .keyboardShortcut(KeyEquivalent("p"), modifiers: [.command, .option])
                    
                        
                    Text(self.themeName ?? "light")
                        .foregroundColor(selectedThemeColors.bgMainColour)
                    
                    
                    
                    
                }
                .frame(width: geometry.size.width / 5, height: geometry.size.height - 20, alignment: .topLeading)
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text("Preferences")
                            .font(.caption)
                            .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("x")
                        }
                    }
                    .padding(.bottom, 5)
                    
                    Text(self.selectedViewName)
                        .foregroundColor(selectedThemeColors.fontMainColour)
                        .font(.title)
                        .padding(.bottom, 25)
                    
                    preferencesSubviews.first(where: {$0.name == self.selectedViewName})?.view
                   
                    
                    Spacer()
                    
                }
                .padding(.trailing, 20)
                // .preferredColorScheme(.light)
                
            }
//            .padding(.bottom, 20)
        }
        .background(selectedThemeColors.bgMainColour)
        .preferredColorScheme(.light)
        

        
//    }
//        .frame(width:350)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(SelectedThemeColors())
    }
}
