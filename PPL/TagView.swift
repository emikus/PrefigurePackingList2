//
//  TagView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 29/04/2021.
//

import SwiftUI
import SFSymbolsPicker

struct TagView: View {
    var tag:Tag
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State var tagIconPickerVisible: Bool = false
    @State private var icon = ""
    @State private var isPresented = true
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    let sfSymbolsPickerWidth: CGFloat = 330
    
    
//    dict[MyRange(range: 0..<5)] = "first"
//    dict[MyRange(range: 5..<10)] = "second"
    
    func setNewIcon(iconName: String) -> Void {
        self.tag.icon = iconName
        try? viewContext.save()
    }
    
//    var sfSymbolsCategories: [Category] = [.devices, .nature]
    
    var body: some View {
        HStack{
            Image(systemName: tag.icon != nil ? tag.icon! : "number")
                .foregroundColor(selectedThemeColors.fontMainColour)
                .popover(
                    isPresented: $tagIconPickerVisible,
                    attachmentAnchor: .point(.trailing),
                    arrowEdge: .leading,
                    content: {
                        IconPickerView(iconTapAction: self.setNewIcon)
                })
                .onTapGesture {
                    print(tag.wrappedIcon, self.tagIconPickerVisible)
//                    print(tag.wrappedIcon)
                    if self.tagIconPickerVisible == true {
                        self.tagIconPickerVisible = false
                    }
                    self.tagIconPickerVisible = true
                    
                }
            
            Text(tag.wrappedName.replacingOccurrences(of: "#", with: ""))
                .foregroundColor(selectedThemeColors.fontMainColour)
                .offset(x: -5, y: 0)
        }
    }
}

//let dict = [
//    "first": 0...4,
//    "second": 5...10
//]



struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        let tag = Tag(context: PersistenceController.preview.container.viewContext)
        TagView(tag: tag)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
    }
}
