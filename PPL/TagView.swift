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
    @State var scaleImage : CGFloat = 1
    @State var iconName: String = ""
    
    
    
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
            VStack {
                GeometryReader { geo in
                Image(systemName: tag.icon != nil ? self.iconName : "number")
                    .foregroundColor(selectedThemeColors.fontMainColour)
                    .popover(
                        isPresented: $tagIconPickerVisible,
                        attachmentAnchor: .point(.trailing),
                        arrowEdge: .leading,
                        content: {
                            IconPickerView(
                                iconTapAction: self.setNewIcon,
                                searchFieldTitle: "Search Tagicons",
                                headerView: AnyView(
                                    HStack {
                                        Image(systemName: tag.icon != nil ? self.iconName : "number")
                                            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
                                    }
                                ),
                                triggerSizeAndCoordinates: geo.frame(in: .global)
                            )
                                .environmentObject(SelectedThemeColors())
                        })
                    .scaleEffect(self.scaleImage)
                    .animation(.easeInOut)
                    .onTapGesture {
                        print(tag.wrappedIcon, self.tagIconPickerVisible)
                        //                    print(tag.wrappedIcon)
                        if self.tagIconPickerVisible == true {
                            self.tagIconPickerVisible = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.tagIconPickerVisible = true
                                    }
                        } else {
                            self.tagIconPickerVisible = true
                        }
                        
                        
                    }
                    .onChange(of: tag.icon, perform: { value in
                        self.scaleImage = 0.01
                        
                        withAnimation(Animation.spring().delay(0.5)) {
                            self.iconName = value!
                            self.scaleImage = 1
                        }
                        
                        
                    })
                }
            }
            .frame(width: 20, height: 20)
            .padding(3)
            .background(Color.orange.opacity(0.9))
            .cornerRadius(3)
            
            Text(tag.wrappedName.replacingOccurrences(of: "#", with: ""))
                .foregroundColor(selectedThemeColors.fontMainColour)
                .offset(x: -5, y: 0)
        }
        .onAppear(perform: {
            self.iconName = self.tag.icon ?? ""
        })
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        let tag = Tag(context: PersistenceController.preview.container.viewContext)
        TagView(tag: tag)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
    }
}
