//
//  IconCategoriesMenuView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 08/07/2021.
//

import SwiftUI
import DYPopoverView
    

struct IconCategoriesMenuView: View {
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @Binding var scrolledToCategoryName: String
    var visibleCategoryName:String
    @State private var allCategoriesArray: [String] = []
    @State var PHSAndAllCategoriesArray: [String] = []
    @State var PHSAndAllCategoriesToolTipsVisibilityArray: Array<Bool> = Array(repeating: false, count: 11)
    
    func getNextCategoryName() -> String {
        let visibleCategoryIndex = PHSAndAllCategoriesArray.firstIndex(of: self.visibleCategoryName)
        let PHSAndAllCategoriesNumber = PHSAndAllCategoriesArray.count
        
        if visibleCategoryIndex! == PHSAndAllCategoriesNumber - 1 {
            return PHSAndAllCategoriesArray[0]
        } else {
            return PHSAndAllCategoriesArray[visibleCategoryIndex! + 1]
        }
    }
    
    func getPreviousCategoryName() -> String {
        let visibleCategoryIndex = PHSAndAllCategoriesArray.firstIndex(of: self.visibleCategoryName)
        let PHSAndAllCategoriesNumber = PHSAndAllCategoriesArray.count
        
        if visibleCategoryIndex! == 0 {
            return PHSAndAllCategoriesArray[PHSAndAllCategoriesNumber - 1]
        } else {
            return PHSAndAllCategoriesArray[visibleCategoryIndex! - 1]
        }
    }
    
    var body: some View {
        HStack(spacing:5) {
            Button(action: {
                scrolledToCategoryName = "Pinned"
            }) {
                Image(systemName: "pin")
                    .onTapGesture {
                        scrolledToCategoryName = "pinned"
                    }
                    .foregroundColor(visibleCategoryName == "Pinned" ? selectedThemeColors.fontMainColour.opacity(0.9) : selectedThemeColors.fontMainColour.opacity(0.6))
                    .background(selectedThemeColors.listHeaderColour.opacity(visibleCategoryName == "Pinned" ? 1.0 : 0.0)
                                    .cornerRadius(10).frame(height: 1).offset(x:0, y: 10))
                    .scaleEffect(visibleCategoryName == "Pinned" ? 1.5 : 1)
                    .animation(.easeInOut)
            }
            .hoverEffect(.lift)
            .onHover { hover in
                self.PHSAndAllCategoriesToolTipsVisibilityArray[0] = hover
            }
            .popoverView(content: {Text("Pinned").foregroundColor(.white)}, background: {selectedThemeColors.listHeaderColour.opacity(0.6)}, isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[0], frame: .constant(CGRect(x: 200, y: 0, width: 80, height: 30)), anchorFrame: nil, popoverType: .popout, position: .topRight, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 15, height: -10)))
            
            Button(action: {
                scrolledToCategoryName = "History"
            }) {
                Image(systemName: "clock")
                    .onTapGesture {
                        scrolledToCategoryName = "History"
                    }
                    .foregroundColor(visibleCategoryName == "History" ? selectedThemeColors.fontMainColour.opacity(0.9) : selectedThemeColors.fontMainColour.opacity(0.6))
                    .background(selectedThemeColors.listHeaderColour.opacity(visibleCategoryName == "History" ? 1.0 : 0.0)
                                    .cornerRadius(10).frame(height: 1).offset(x:0, y: 10))
                    .scaleEffect(visibleCategoryName == "History" ? 1.5 : 1)
                    .animation(.easeInOut)
            }
            //                    .hoverEffect(.lift)
            .onHover { hover in
                self.PHSAndAllCategoriesToolTipsVisibilityArray[1] = hover
                
                print(self.PHSAndAllCategoriesToolTipsVisibilityArray[1])
                
            }
            .popoverView(content: {Text("History").foregroundColor(.white)}, background: {selectedThemeColors.listHeaderColour.opacity(0.6)}, isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[1], frame: .constant(CGRect(x: 200, y: 0, width: 80, height: 30)), anchorFrame: nil, popoverType: .popout, position: .top, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 10, height: 0)))
            //
            Button(action: {
                scrolledToCategoryName = "Suggestions"
            }) {
                Image(systemName: "lasso.sparkles")
                    .foregroundColor(visibleCategoryName == "Suggestions" ? selectedThemeColors.fontMainColour.opacity(0.9) : selectedThemeColors.fontMainColour.opacity(0.6))
                    .background(selectedThemeColors.listHeaderColour.opacity(visibleCategoryName == "Suggestions" ? 1.0 : 0.0)
                                    .cornerRadius(10).frame(height: 1).offset(x:0, y: 10))
                    .scaleEffect((visibleCategoryName == "Suggestions") ? 1.5 : 1)
                    .animation(.easeInOut)
                
            }
            .hoverEffect(.lift)
            .onHover { hover in
                self.PHSAndAllCategoriesToolTipsVisibilityArray[2] = hover
            }
            .popoverView(content: {Text("Suggestions").foregroundColor(.white)}, background: {selectedThemeColors.listHeaderColour.opacity(0.6)}, isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[2], frame: .constant(CGRect(x: 0, y: 0, width: 120, height: 30)), anchorFrame: nil, popoverType: .popout, position: .top, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 10, height: 0)))
            
            ForEach (Array(allCategoriesArray.enumerated()), id: \.offset) {index, category in
                Button(action: {
                    scrolledToCategoryName = category
                }) {
                    Image(systemName: symbols[category]![0])
                        .padding(5)
                        .foregroundColor(visibleCategoryName == category ? selectedThemeColors.listHeaderColour : categoriesRainbowColors[category])
                        .background(selectedThemeColors.listHeaderColour
                                        .opacity(visibleCategoryName == category ? 1.0 : 0.0)
                                        .cornerRadius(10)
                                        .frame(height: 2).offset(x:0, y: 10))
                        .scaleEffect((visibleCategoryName == category) ? 1.5 : 1)
                        .animation(.easeInOut)
                        .help("dupa")
                    
                }
                .onHover { hover in
                    self.PHSAndAllCategoriesToolTipsVisibilityArray[index + 3] = hover
                }
                .popoverView(content: {Text(category).foregroundColor(Color.white)}, background: {categoriesRainbowColors[category].opacity(0.8)}, isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[index + 3], frame: .constant(CGRect(x: 0, y: 0, width: category.count + 100, height: 30)),  anchorFrame: nil, popoverType: .popout, position: .top, viewId: String(index + 3) + "Popover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 15, height: 0)))
                //                      }
                
                //Hidden buttons to add shortcuts to shortcuts menu, buttons with only imgs are not included :(
                VStack {
                    Button(action: {
                        scrolledToCategoryName = "pinned"
                    }) {
                        Text("Pinned")
                    }
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("p"), modifiers: [.command, .shift]))
                    
                    Button(action: {
                        scrolledToCategoryName = "History"
                    }) {
                        Text("History")
                    }
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("h"), modifiers: [.command, .shift]))
                    
                    Button(action: {
                        scrolledToCategoryName = "Suggestions"
                    }) {
                        Text("Suggestions")
                    }
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("s"), modifiers: [.command, .shift]))
                    
                    ForEach (Array(allCategoriesArray.enumerated()), id: \.offset) {index, category in
                        Button(action: {
                            scrolledToCategoryName = category
                        }) {
                            Text(category)
                            
                            
                        }
                        .hoverEffect(.lift)
                        .keyboardShortcut(KeyboardShortcut(KeyEquivalent(Character(String(index + 1))), modifiers: [.command]))
                        
                        
                        Button(action: {
                            scrolledToCategoryName = getNextCategoryName()
                        }) {
                            Text("Next category ->")
                        }
                        .keyboardShortcut(KeyboardShortcut(KeyEquivalent.tab, modifiers: [.command, .shift, .option]))
                        
                        
                        
                        Button(action: {
                            scrolledToCategoryName = getPreviousCategoryName()
                        }) {
                            Text("Previous category <-")
                        }
                        .keyboardShortcut(KeyboardShortcut(KeyEquivalent.tab, modifiers: [.command, .shift, .option, .control]))
                        
                    }
                }
                .font(.system(size: 0.1))
                
                
                
                
            }
            //                    }
            Spacer()
            Image(systemName: "gearshape.fill")
                .font(.title)
                .foregroundColor(selectedThemeColors.fontSecondaryColour)
                .onHover { hover in
                    self.PHSAndAllCategoriesToolTipsVisibilityArray[10] = hover
                }
                .popoverView(content: {Text("Go to settings").foregroundColor(.white)}, background: {selectedThemeColors.fontSecondaryColour.opacity(0.6)}, isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[10], frame: .constant(CGRect(x: 200, y: 0, width: 120, height: 30)), anchorFrame: nil, popoverType: .popout, position: .topLeft, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 5, height: -10)))
        }
        .animation(.easeInOut)
        .onAppear{
            
//            for (_, value) in symbols {
//                allIconsArray += value
//            }
//            allIconsArray = Array(Set(allIconsArray))
            allCategoriesArray = Array(symbols.keys).sorted()
            PHSAndAllCategoriesArray = ["Pinned", "History", "Suggestions"] + allCategoriesArray
            
//            PHSAndAllCategoriesToolTipsVisibilityArray =
            
            
//            self.last24Icons = []
//            self.pinnedIcons = []
        }
    }
}


struct IconCategoriesMenuView_Previews: PreviewProvider {
    static var previews: some View {
        IconCategoriesMenuView(scrolledToCategoryName: .constant("Pinned"), visibleCategoryName: "Pinned")
            .environmentObject(SelectedThemeColors())
    }
}
