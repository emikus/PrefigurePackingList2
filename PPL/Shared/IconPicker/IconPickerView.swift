//
//  IconPickerView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 28/05/2021.
//

import SwiftUI
import SFSymbolsPicker

struct IconPickerView: View {
    var iconTapAction: (_ iconName: String) -> Void
    var searchFieldTitle: String?
    var headerView: AnyView?
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State private var searchIconName:String = ""
    @State private var scrolledToCategoryName:String = ""
    @State private var allIconsArray: [String] = []
    @State private var allCategoriesArray: [String] = []
    @State private var iconsCategoriesOffsetsReverese = Dictionary<MyRange, String>()
    @State private var iconsCategoriesOffsets: [String: [Int]] = [:]
    @State private var iconsCategoriesSizes: [String: CGFloat] = [:]
    @State private var visibleCategoryName: String = "Pinned"
    @State private var hoveredCategoryName: String = ""
    @State private var visibleCategoryRangeLowerBound: Int = -64
    @State private var scrollOffset: ViewOffsetKey.Value = -64
    @State private var initialScrollOffset: ViewOffsetKey.Value = -1000
    @State private var popoverVisible: Bool = true
    
    
    
    
    @AppStorage("pinnedIcons") var pinnedIcons: [String] = []
    @AppStorage("last24Icons") var last24Icons: [String] = []
    @Namespace private var animation
    @State var PHSAndAllCategoriesArray: [String] = []
    @State var PHSAndAllCategoriesToolTipsVisibilityArray: Array<Bool> = Array(repeating: false, count: 10)
    
    @State var aaaArray: [String: Bool] = ["Pinned": true
    ]
    private let gridSpacing = 10
    private let iconWidth = 24
    private let smartCategoriesNumber = 3
    
    let rows = [
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0),
        GridItem(.fixed(40.00), spacing: 0)
    ]
    
    func addIconToPinned(iconName: String) -> Void {
        if !pinnedIcons.contains(iconName) {
            pinnedIcons.insert(iconName, at: 0)
        }
    }
    
    func removeIconFromPinned(iconName: String) -> Void {
        if let iconNameIndex = pinnedIcons.firstIndex(of: iconName) {
            pinnedIcons.remove(at: iconNameIndex)
        }
    }
    
    func addIconToLast24(iconName: String) -> Void {
        
        if let iconNameIndex = last24Icons.firstIndex(of: iconName) {
            last24Icons.remove(at: iconNameIndex)
        }
        
        if last24Icons.count < 24 {
            withAnimation {
                last24Icons.insert(iconName, at: 0)
            }
        } else {
            last24Icons.remove(at: 23)
            last24Icons.insert(iconName, at: 0)
        }
    }
    
    func setCategoriesSizesAndOffsets() -> Void {
        if self.iconsCategoriesSizes.count == symbols.count + self.smartCategoriesNumber && self.iconsCategoriesOffsetsReverese.count == 0 {
            
            var rangeStart = Int(self.initialScrollOffset)
            
            for categoryName in Array(iconsCategoriesSizes.keys).sorted() {
                let rangeMax = rangeStart + Int(self.iconsCategoriesSizes[categoryName]!) + 27
                
                self.iconsCategoriesOffsetsReverese[MyRange(range: rangeStart..<rangeMax)] = categoryName
                self.iconsCategoriesOffsets[categoryName] = [rangeStart, rangeMax]
                rangeStart = rangeMax
            }
        }
    }

    func setVisibleCategoryNameAsTitle(offsetKey: ViewOffsetKey.Value) -> Void {
        if self.iconsCategoriesOffsetsReverese[Int(offsetKey)].count > 0 {
            let visibleCategoryName = self.iconsCategoriesOffsetsReverese[Int(offsetKey)][0].replacingOccurrences(of: "AAPinned", with: "Pinned").replacingOccurrences(of: "AHistory", with: "History").replacingOccurrences(of: "ASuggestions", with: "Suggestions")
            self.visibleCategoryName = visibleCategoryName
        }
    }
    
    func getShortcutNumber(number: Int) -> String {
        return String(number + 3)
    }
    
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
        ZStack {
            
            VStack(alignment: .leading) {
                
                
                
                
                
                
                
                
//                Text("Hovered is: \(hoveredCategoryName)")
//                                                .help("dupa")
                
                
                
                SearchBar(
                    text: $searchIconName,
                    searchFieldTitle: searchFieldTitle != nil ? searchFieldTitle! : "Search icons"
                )
                .padding(10)
                .background(selectedThemeColors.bgSecondaryColour)
                .foregroundColor(selectedThemeColors.fontSecondaryColour)
                .cornerRadius(10)
                .environmentObject(SelectedThemeColors())
                
                if headerView != nil {
                    HStack {
                        Text("You're changing:")
                            
                        headerView
                    }
                    .foregroundColor(selectedThemeColors.fontSecondaryColour)
                }
                
                //                Text(visibleCategoryName)
                //                    .foregroundColor(selectedThemeColors.fontMainColour)
                
                ScrollView(. horizontal) {
                    ScrollViewReader { scrollView in
                        
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Text("Pinned")
                                    .iconsSectionHeaderStyle()
                                    .offset(x: self.scrollOffset + 69)
                                
                                if (pinnedIcons.count == 0) {
                                    Spacer()
                                    Text("Long press any icon to keep it here. Do the same within this section to unpin it.")
                                        .font(.footnote)
                                        .frame(width: 70)
                                    //                                        .padding([.top], 60)
                                    Spacer()
                                    
                                } else {
                                    LazyHGrid(rows: rows, spacing: CGFloat(gridSpacing)) {
                                        ForEach(pinnedIcons, id: \.self) { iconName in
                                            
                                            Image(systemName: iconName)
                                                .onTapGesture {
                                                    self.iconTapAction(iconName)
                                                }
                                                .onLongPressGesture {
                                                    self.removeIconFromPinned(iconName: iconName)
                                                }
                                                .frame(width: CGFloat(iconWidth))
                                            
                                            
                                        }
                                    }
                                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                    .frame(height: 220.00)
                                    
                                }
                            }
                            .id("pinned")
                            .frame(width:pinnedIcons.count > 18 ? CGFloat((ceil(Double(Float(pinnedIcons.count)/Float(6))))*34) : 90,height: 255.00)
                            .padding(10)
                            .background(selectedThemeColors.bgSecondaryColour)
                            .cornerRadius(10)
                            .onAppear {
                                // the horizontal available space is size.width
                                self.iconsCategoriesSizes["AAPinned"] = pinnedIcons.count > 18 ? CGFloat((ceil(Double(Float(pinnedIcons.count)/Float(6))))*34) : 90
                                
                                self.setCategoriesSizesAndOffsets()
                            }
                            
                            VStack(alignment: .leading) {
                                Text("History")
                                    .iconsSectionHeaderStyle()
                                    .offset(x: self.visibleCategoryName == "History" ? (CGFloat(Int(self.scrollOffset)) - 40) : 0)
                                
                                if (last24Icons.count == 0) {
                                    Spacer()
                                    Text("Soon will be full :)")
                                        .font(.footnote)
                                        .frame(width: 70)
                                    Spacer()
                                    
                                } else {
                                    LazyHGrid(rows: rows, spacing: CGFloat(gridSpacing)) {
                                        ForEach(last24Icons, id: \.self) { iconName in
                                            
                                            Image(systemName: iconName)
                                                .onTapGesture {
                                                    self.iconTapAction(iconName)
                                                }
                                                .onLongPressGesture {
                                                    self.addIconToPinned(iconName: iconName)
                                                }
                                                .frame(width: CGFloat(iconWidth))
                                        }
                                    }
                                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                    .frame(height: 220.00)
                                    
                                }
                            }
                            .id("History")
                            .frame(width: last24Icons.count > 12 ? CGFloat((ceil(Double(Float(last24Icons.count)/Float(6))))*34) : 90,height: 255.00)
                            .padding(10)
                            .background(selectedThemeColors.bgSecondaryColour)
                            .cornerRadius(10)
                            .fixedSize()
                            .onAppear {
                                // the horizontal available space is size.width
                                self.iconsCategoriesSizes["AHistory"] = CGFloat((ceil(Double(Float(last24Icons.count)/Float(6))))*34)
                                
                                self.setCategoriesSizesAndOffsets()
                            }
                            
                            
                            
                            
                            
                            VStack(alignment: .leading) {
                                Text("Suggestions")
                                    .iconsSectionHeaderStyle()
                                    .offset(x: self.visibleCategoryName == "Suggestions" ? (CGFloat(Int(self.scrollOffset)) - 210) : 0)
                                
                                
                                Text("Soon will be full :)")
                                    .font(.footnote)
                                    .frame(width: 70)
                                Spacer()
                            }
                            .id("Suggestions")
                            .frame(width: 90, height: 255.00)
                            .padding(10)
                            .background(selectedThemeColors.bgSecondaryColour)
                            .cornerRadius(10)
                            .fixedSize()
                            .onAppear {
                                // the horizontal available space is size.width
                                self.iconsCategoriesSizes["ASuggestions"] = 90
                                
                                self.setCategoriesSizesAndOffsets()
                            }
                            
                            Divider()
                            
                            
                            
                            ForEach (Array(symbols.keys).sorted(), id: \.self) {category in
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(systemName: symbols[category]![0])
                                            .foregroundColor(categoriesRainbowColors[category])
                                        Text(category)
                                    }
                                    .help("Dupa blada")
                                    .iconsSectionHeaderStyle()
                                    .offset(x: self.visibleCategoryName == category ? (self.iconsCategoriesOffsets[category] != nil ? CGFloat(Int(self.scrollOffset) - self.iconsCategoriesOffsets[category]![0]) : 0) : 0, y: 0)
                                    
                                    LazyHGrid(rows: rows, spacing: CGFloat(gridSpacing)) {
                                        ForEach(symbols[category]!, id: \.self) { iconName in
                                            
                                            Image(systemName: iconName)
                                                .onTapGesture {
                                                    self.iconTapAction(iconName)
                                                    self.addIconToLast24(iconName: iconName)
                                                }
                                                .foregroundColor(categoriesRainbowColors[category])
                                                .frame(width: CGFloat(iconWidth))
                                        }
                                    }
                                    .frame(height: 220.00)
                                    
                                }
                                .frame(width: CGFloat((ceil(Double(Float(symbols[category]!.count)/Float(6))))*34))
                                .id(category)
                                .padding(10)
                                .background(categoriesRainbowColors[category].opacity(0.6))
                                .cornerRadius(10)
                                .fixedSize()
                                .onAppear {
                                    self.iconsCategoriesSizes[category] = CGFloat((ceil(Double(Float(symbols[category]!.count)/Float(6))))*34)
                                    //                                    }
                                    self.setCategoriesSizesAndOffsets()
                                }
                            }
                        }
                        .onChange(of: scrolledToCategoryName, perform: { value in
                            withAnimation{
                                scrollView.scrollTo(scrolledToCategoryName, anchor: .leading)
                            }
                        })
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                   value: -$0.frame(in: .named("scroll")).origin.x)
                        })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            self.scrollOffset = $0
                            if self.initialScrollOffset == -1000 {
                                self.initialScrollOffset =  $0
                            }
                            setVisibleCategoryNameAsTitle(offsetKey: $0)
                        }
                    }
                }
                .foregroundColor(selectedThemeColors.listHeaderColour)
                
                HStack {
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
                    .popover(
                        isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[0],
                        attachmentAnchor: .point(.trailing),
                        arrowEdge: .leading,
                        content: {
                            Text("Pinned")
                        })
                    
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
                    .hoverEffect(.lift)
                    
                    Button(action: {
                        scrolledToCategoryName = "Suggestions"
                    }) {
                        Image(systemName: "lasso.sparkles")
                            .foregroundColor(visibleCategoryName == "Suggestions" ? selectedThemeColors.fontMainColour.opacity(0.9) : selectedThemeColors.fontMainColour.opacity(0.6))
                            .background(selectedThemeColors.listHeaderColour.opacity(visibleCategoryName == "Suggestions" ? 1.0 : 0.0)
                                            .cornerRadius(10).frame(height: 1).offset(x:0, y: 10))
                            .scaleEffect((visibleCategoryName == "Suggestions" || hoveredCategoryName == "Suggestions") ? 1.5 : 1)
                            .animation(.easeInOut)
                        
                    }
                    .hoverEffect(.lift)
                    
                    ScrollView(. horizontal) {
                        HStack(spacing: 3){
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
                                        .scaleEffect((visibleCategoryName == category || hoveredCategoryName == category) ? 1.5 : 1)
                                        .animation(.easeInOut)
                                        .help("dupa")
                                    
                                }
                                .hoverEffect(.lift)
//                                .popover(
//                                    isPresented: self.$PHSAndAllCategoriesToolTipsVisibilityArray[category],
//                                    attachmentAnchor: .point(.trailing),
//                                    arrowEdge: .leading,
//                                    content: {
//                                        Text("dupa")
//                                    })
                                
                            }
                            
                            //Hidden buttons to add shortcuts to shortcuts menu, buttons with only imgs are not included :(
                            VStack {
                                Button(action: {
                                    scrolledToCategoryName = "Pinned"
                                }) {
                                    Text("Pinned")
                                }
                                .keyboardShortcut(KeyboardShortcut(KeyEquivalent("p"), modifiers: [.command, .shift, .option]))
                                
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
                                        //                                    print(type(of: Character(String((index + 4))))
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
                    }
                    Spacer()
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                }
                .animation(.easeInOut)
            }
            .padding(10)
            .background(selectedThemeColors.bgMainColour)
            .frame(width: 410)
            
            if self.searchIconName.count > 2 {
//                Text("Search results number: \(self.allIconsArray.filter({$0.contains(self.searchIconName.lowercased())}).count)")
//                    .foregroundColor(.red)
//                    .offset(x: 0, y: -80)
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
                            LazyHGrid(rows: rows, spacing: CGFloat(gridSpacing)) {
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
                .background(selectedThemeColors.bgSecondaryColour.opacity(0.9))
                .cornerRadius(15)
//                .border()
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                .foregroundColor(selectedThemeColors.fontMainColour)
                .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(selectedThemeColors.fontSecondaryColour, lineWidth: 1)
                    )
            }
        }
        .onAppear{
            
            for (_, value) in symbols {
                allIconsArray += value
            }
            allIconsArray = Array(Set(allIconsArray))
            allCategoriesArray = Array(symbols.keys).sorted()
            PHSAndAllCategoriesArray = ["Pinned", "History", "Suggestions"] + allCategoriesArray
            
//            PHSAndAllCategoriesToolTipsVisibilityArray =
            
            
//            self.last24Icons = []
//            self.pinnedIcons = []
        }

    }
}


struct IconPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        func printString(string: String) -> Void {
            print(string)
        }
        
        return IconPickerView(
            iconTapAction: printString,
            headerView: AnyView(Text("dupa:)")))
            .environmentObject(SelectedThemeColors())
    }
}




let categoriesRainbowColors: [String: Color] = [
    "Connectivity": Color(hex: "#D82735"),
    "Devices": Color(hex: "#FF9135"),
    "Health": Color(hex: "#FFEF00"),
    "Multimedia": Color(hex: "#00CC00"),
    "Nature": Color(hex: "#06BBFC"),
    "People": Color(hex: "#0052A5"),
    "Time": Color(hex: "#69107D"),
]



    
    



