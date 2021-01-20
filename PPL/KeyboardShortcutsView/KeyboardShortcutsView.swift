//
//  KeyboardShortcutsView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 10/01/2021.
//

import SwiftUI

struct KeyboardShortcutsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var selectedViewName = "⦿ General"
    var viewsNames:[String] = [
        "⦿ General",
        "⭕️ Aim",
        "🟥 Plan",
        "➕ Middle view",
        "🗄 Pack",
        "🎒 Buy"
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
                        }
                        .buttonStyle(KeyboardShortcutsListStyle())
                        .frame(width: geometry.size.width / 5, height: 34, alignment: .leading)
                        .background(self.selectedViewName == name ? Color.gray : Color.gray.opacity(0))
                        .cornerRadius(3)
                    }
                    
                    
                    
                    

                    Divider()
                    HStack {
                    Text("Next")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        Spacer()
                        Text("⌥ ⌘ N")
                            .padding(4)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(3)
                            
                    }
                    .font(.footnote)
                    
                    HStack {
                    Text("Previous")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        Spacer()
                        Text("⌥ ⌘ P")
                            .padding(4)
                            .background(Color.gray.opacity(0.5))
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
                    
                        
                    
                    
                    
                    
                }
                .frame(width: geometry.size.width / 5, height: geometry.size.height - 20, alignment: .topLeading)
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text("Keyboard Shortcuts")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("x")
                        }
                    }
                    .padding(.bottom, 5)
                    
                    Text(self.selectedViewName)
                        .font(.title)
                        .padding(.bottom, 25)
                    
                    ForEach(Array(keyboardShortcutsList[self.selectedViewName]!), id: \.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text(value)
                                .padding(8)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(3)
                                
                        }
                        .padding(8)
                    }
                    Spacer()
                    
                }
                .padding(.trailing, 20)
                
            }
//            .padding(.bottom, 20)
        }

        
//    }
//        .frame(width:350)
    }
}

struct KeyboardShortcutsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardShortcutsView()
//            .previewLayout(.fixed(width: 2688, height: 1242))
    }
}
