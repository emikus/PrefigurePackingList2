//
//  IconPickerSearchResults.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 09/07/2021.
//

import SwiftUI

struct IconPickerSearchResults: View {
    @Binding var searchIconName:String
    var iconTapAction: (_ iconName: String) -> Void
    
    @State private var allIconsArray: [String] = []
    let rows = [
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0)
    ]
    private let gridSpacing = 10
    
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.allIconsArray.filter({$0.contains(self.searchIconName.lowercased())}).count > 0 {
                HStack {
                    Text("Results for ") + Text(self.searchIconName).bold() + Text(":")
                    Spacer()
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(selectedThemeColors.listHeaderColour)
                        .onTapGesture {
                            self.searchIconName = ""
                        }
                }
                
                ScrollView {
                    LazyVGrid(columns: rows, spacing: CGFloat(gridSpacing)) {
                        //                List{
                        ForEach(self.allIconsArray.filter({$0.contains(self.searchIconName.lowercased())}), id: \.self) { symbol in
                            
                            Image(systemName: symbol)
                                
                                .onTapGesture {
                                    self.iconTapAction(symbol)
                                }
                        }
                    }
                }
            } else {
                HStack {
                    Text("No icons for ") + Text(self.searchIconName).bold() + Text(":(")
                    Spacer()
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        .onTapGesture {
                            self.searchIconName = ""
                        }
                }
            }
//
        }
        .padding()
        .frame(minWidth: 0, maxWidth: 260, minHeight: 0, maxHeight: self.allIconsArray.filter({$0.contains(self.searchIconName.lowercased())}).count > 0 ? 275 : 40)
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
//                .border()
        .animation(.easeIn)
        .foregroundColor(selectedThemeColors.listHeaderColour)
        .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedThemeColors.fontSecondaryColour.opacity(0.8), lineWidth: 1)
            )
        .onAppear{
            
            for (_, value) in symbols {
                allIconsArray += value
            }
            allIconsArray = Array(Set(allIconsArray))
        }
    }
}

struct IconPickerSearchResults_Previews: PreviewProvider {
    static var previews: some View {
        func printString(string: String) -> Void {
            print(string)
        }
        return IconPickerSearchResults(
            searchIconName: .constant("rec"),
            iconTapAction: printString
        )
        .environmentObject(SelectedThemeColors())
    }
}
