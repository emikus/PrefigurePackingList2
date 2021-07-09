//
//  IconPickerView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 28/05/2021.
//

import SwiftUI
import SFSymbolsPicker
import DYPopoverView

struct IconPickerView: View {
    var iconTapAction: (_ iconName: String) -> Void
    var searchFieldTitle: String?
    var headerView: AnyView?
    var triggerSizeAndCoordinates: CGRect?
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State private var searchIconName:String = ""
    @State private var scrolledToCategoryName:String = ""
    @State private var visibleCategoryName: String = "Pinned"
    @State private var cleanHistoryButtonTipVisibility: Bool = false
    
    @AppStorage("last24Icons") var last24Icons: [String] = []
    
    @State private var headerViewSizeAndGlobalCoordinates: CGRect? = nil

    private let headerLocalY: CGFloat = 80
    
    var body: some View {
        ZStack {
            
            // triggering view to headerView connector
            if self.headerViewSizeAndGlobalCoordinates != nil {
                Path { path in
                    path.move(to: CGPoint(x: 15, y: headerLocalY + 3))
                    path.addLine(to:CGPoint(x: 5, y: headerLocalY + 3))
                    path.addLine(to: CGPoint(x: 5, y: headerLocalY + self.triggerSizeAndCoordinates!.midY - self.headerViewSizeAndGlobalCoordinates!.midY))
                    path.addLine(to: CGPoint(x: 0, y: headerLocalY + self.triggerSizeAndCoordinates!.midY - self.headerViewSizeAndGlobalCoordinates!.midY))
                }
                .stroke(Color.orange, lineWidth: 3)
                .zIndex(5)
                .offset(x: -7)
            }
            
            VStack(alignment: .leading) {
                
                
                SearchBar(
                    text: $searchIconName,
                    searchFieldTitle: searchFieldTitle != nil ? searchFieldTitle! : "Search icons"
                )
                .padding(10)
                .background(selectedThemeColors.bgSecondaryColour)
                .foregroundColor(selectedThemeColors.fontSecondaryColour)
                .cornerRadius(10)
                .environmentObject(SelectedThemeColors())
                
                
                HStack {
                    GeometryReader { geo in
                        
                        if headerView != nil {
                            headerView
                                .padding(3)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange, lineWidth: 3)
                                )
                                .onAppear {
                                    print(geo.frame(in: .global))
                                    print(geo.frame(in: .local))
                                    self.headerViewSizeAndGlobalCoordinates = geo.frame(in: .global)
                                }
                                .offset(x: 5, y: -3)
                        }
                    }
                    .foregroundColor(selectedThemeColors.fontSecondaryColour)
                    .frame(height: 17)
                        Spacer()
                        Button(action: {
                            self.last24Icons = []
                        }) {
                            Image(systemName: "trash")
                        }
                        .disabled(self.last24Icons.count == 0)
                        .onHover { hover in
                            self.cleanHistoryButtonTipVisibility = hover
                        }
                        .popoverView(content: {Text("Start new life:)").foregroundColor(.orange)}, background: {Color.white.opacity(0.8)}, isPresented: self.$cleanHistoryButtonTipVisibility, frame: .constant(CGRect(x: 200, y: 0, width: 120, height: 30)), anchorFrame: nil, popoverType: .popout, position: .topLeft, viewId: "thirdPopover", settings: DYPopoverViewSettings(arrowLength: 10))
                    
                }
                
                IconCategoriesView(
                    scrolledToCategoryName: $scrolledToCategoryName,
                    visibleCategoryName: $visibleCategoryName,
                    iconTapAction: self.iconTapAction
                )
                                
                IconCategoriesMenuView(
                    scrolledToCategoryName: $scrolledToCategoryName,
                    visibleCategoryName: self.visibleCategoryName
                )
            }
            .padding(10)
//            .background(selectedThemeColors.bgMainColour)
            .frame(width: 410)
            
            if self.searchIconName.count > 2 {
                IconPickerSearchResults(
                    searchIconName: $searchIconName,
                    iconTapAction: self.iconTapAction
                )
            }
        }
        .padding([.leading, .trailing], 5)
        .onAppear{
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
            headerView: AnyView(Text("#")),
            triggerSizeAndCoordinates: CGRect(x: 27.0, y: 481.0, width: 100.0, height: 20.0))
            .environmentObject(SelectedThemeColors())
    }
}








    
    



