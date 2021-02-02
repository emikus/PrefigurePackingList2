//
//  SettingsView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 23/01/2021.
//

import SwiftUI

//var a:String = "a"

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("themeName") var themeName: String?
    
    @State var selectedViewName = "App themes"
    var viewsNames:[String] = [
        "App themes"
    ]
    
    
    func selectNextView() {
        let selectedViewIndex:Int = self.viewsNames.firstIndex(of: self.selectedViewName)!
        let isLastItemSelected:Bool = selectedViewIndex + 1 == self.viewsNames.count ? true : false
        
        if isLastItemSelected == true {
            self.selectedViewName = self.viewsNames[0]
        } else {
            self.selectedViewName = self.viewsNames[selectedViewIndex + 1]
        }
    }
    
    func selectPreviousView() {
        let selectedViewIndex:Int = self.viewsNames.firstIndex(of: self.selectedViewName)!
        let isFirstItemSelected:Bool = selectedViewIndex == 0 ? true : false
        
        if isFirstItemSelected == true {
            self.selectedViewName = self.viewsNames[self.viewsNames.count - 1]
        } else {
            self.selectedViewName = self.viewsNames[selectedViewIndex - 1]
        }
    }
    
    var body: some View {
//        VStack {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading) {
                    
                    
                    ForEach(Array(self.viewsNames), id: \.self) { name in
                        Button(action: {
                            self.selectedViewName = name
                        }) {
                            Text(name)
                                .foregroundColor(fontMainColour)
                        
                        }
                        .buttonStyle(KeyboardShortcutsListStyle())
                        .frame(width: geometry.size.width / 5, height: 34, alignment: .leading)
                        .background(self.selectedViewName == name ? fontSecondaryColour : fontSecondaryColour.opacity(0))
                        .cornerRadius(3)
                    }
                    
                    Divider()
                    HStack {
                    Text("Next")
                        .font(.footnote)
                        .foregroundColor(fontSecondaryColour)
                        Spacer()
                        Text("⌥ ⌘ N")
                            .padding(4)
                             .background(fontSecondaryColour.opacity(0.5))
                            .cornerRadius(3)
                            
                    }
                    .font(.footnote)
                    
                    HStack {
                    Text("Previous")
                        .font(.footnote)
                        .foregroundColor(fontSecondaryColour)
                        Spacer()
                        Text("⌥ ⌘ P")
                            .padding(4)
                            .background(fontSecondaryColour.opacity(0.5))
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
                        .foregroundColor(bgMainColour)
                    
                    
                    
                    
                }
                .frame(width: geometry.size.width / 5, height: geometry.size.height - 20, alignment: .topLeading)
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text("Settings")
                            .font(.caption)
                            .foregroundColor(fontSecondaryColour)
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("x")
                        }
                    }
                    .padding(.bottom, 5)
                    
                    Text(self.selectedViewName)
                        .foregroundColor(fontMainColour)
                        .font(.title)
                        .padding(.bottom, 25)
                    
                    ThemesView()
                    
                    Spacer()
                    
                }
                .padding(.trailing, 20)
                // .preferredColorScheme(.light)
                
            }
//            .padding(.bottom, 20)
        }
        .background(bgMainColour)
        .preferredColorScheme(.light)
        

        
//    }
//        .frame(width:350)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
