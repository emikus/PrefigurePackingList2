//
//  IconCategoriesView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 09/07/2021.
//

import SwiftUI
import DYPopoverView

struct IconCategoriesView: View {
    @Binding var scrolledToCategoryName: String
    @Binding var visibleCategoryName: String
    var iconTapAction: (_ iconName: String) -> Void
    
    @State private var visibleCategoryRangeLowerBound: Int = -64
    @State private var scrollOffset: ViewOffsetKey.Value = -64
    @State private var cleanHistoryButtonTipVisibility: Bool = false
    @State private var iconsCategoriesOffsetsReverese = Dictionary<MyRange, String>()
    @State private var iconsCategoriesOffsets: [String: [Int]] = [:]
    @State private var iconsCategoriesSizes: [String: CGFloat] = [:]
    @State private var initialScrollOffset: ViewOffsetKey.Value = -1000
    @State private var headerViewSizeAndGlobalCoordinates: CGRect? = nil
    
    
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @AppStorage("pinnedIcons") var pinnedIcons: [String] = []
    @AppStorage("last24Icons") var last24Icons: [String] = []
    
    private let gridSpacing = 10
    private let iconWidth = 24
    private let smartCategoriesNumber = 3
    private let headerLocalY: CGFloat = 80
    
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
    
    
    var body: some View {
        ScrollView(. horizontal) {
            ScrollViewReader { scrollView in
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Pinned")
                            .smartIconsSectionHeaderStyle()
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
                        HStack {
                            Text("History")
                                .smartIconsSectionHeaderStyle()
                                .offset(x: self.visibleCategoryName == "History" ? (CGFloat(Int(self.scrollOffset)) - 40) : 0)
                            Spacer()
                            Button(action: {
                                self.last24Icons = []
                            }) {
                                Text("Clear history")
                                    .multilineTextAlignment(.trailing)
                                    .lineSpacing(-15)
                                    .font(.system(size: 10))
                                    .frame(width: 50, height: 25)
                                    .foregroundColor(.red)
                            }
                            .disabled(self.last24Icons.count == 0)
                            .onHover { hover in
                                self.cleanHistoryButtonTipVisibility = hover
                            }
                            .popoverView(content: {Text("Start new life:)").foregroundColor(.orange)}, background: {Color.white.opacity(0.8)}, isPresented: self.$cleanHistoryButtonTipVisibility, frame: .constant(CGRect(x: 200, y: 0, width: 120, height: 30)), anchorFrame: nil, popoverType: .popout, position: .bottomLeft, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10, offset: CGSize(width: 5, height: 25)))
                            
                        }
                        .zIndex(100)
                        
                        if (last24Icons.count == 0) {
                            Spacer()
                            Text("Make history!")
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
                            .smartIconsSectionHeaderStyle()
                            .offset(x: self.visibleCategoryName == "Suggestions" ? (CGFloat(Int(self.scrollOffset)) - 210) : 0)
                        if self.visibleCategoryName == "Suggestions" {
                            Text("Wait till iOS 15 and Xcode 13!!!")
                        } else {
                            
                            Text("Soon will be full :)")
                                .font(.footnote)
                                .frame(width: 70)
                            
                            Spacer()
                        }
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
                                    .padding(0)
                                    .background(Color.white.opacity(0.6))
                                    .foregroundColor(categoriesRainbowColors[category])
                                    .cornerRadius(3)
                                Text(category)
                            }
                            .iconsSectionHeaderStyle()
                            .background(categoriesRainbowColors[category])
                            .cornerRadius(5)
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

    }
}

struct IconCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        func printString(string: String) -> Void {
            print(string)
        }
        return IconCategoriesView(
            scrolledToCategoryName: .constant("Pinned"),
            visibleCategoryName: .constant("Pinned"),
            iconTapAction: printString
        )
        .environmentObject(SelectedThemeColors())
    }
}
