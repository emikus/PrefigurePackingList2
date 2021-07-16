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
            HStack(alignment: .center){
                GeometryReader { geo in
                    Image(systemName: tag.icon != nil ? self.iconName : "person.3")
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedThemeColors.fontMainColour)
                        .popover(
                            isPresented: $tagIconPickerVisible,
                            attachmentAnchor: .point(.trailing),
                            arrowEdge: .leading,
                            content: {
                                IconPickerView(
                                    iconTapAction: self.setNewIcon,
                                    searchFieldTitle: "Search Tagicons",
                                    headerView: AnyView(IconPickerTagPreview(tag: tag)),
                                    triggerSizeAndCoordinates: geo.frame(in: .global),
                                    connectorColor: tag.iconCategoryColor
                                )
                                .environmentObject(SelectedThemeColors())
                            })
                        
                        .scaleEffect(self.scaleImage)
                        .animation(.easeInOut)
                        
                        .onTapGesture {
                            //                    print(tag.wrappedIcon)
                            if self.tagIconPickerVisible == true {
                                self.tagIconPickerVisible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.tagIconPickerVisible = true
                                }
                            } else {
                                self.tagIconPickerVisible = true
                            }
                            
//                            self.tagIconPickerVisible = true
                            
                            
                        }
                        .onChange(of: tag.icon, perform: { value in
                            self.scaleImage = 0.01
                            
                            withAnimation(Animation.spring().delay(0.5)) {
                                print(value!)
                                self.iconName = value!
                                self.scaleImage = 1
                            }
                            
                            
                        })
                        .background(tag.iconCategoryColor.opacity(0.9))
                        .cornerRadius(5)
//                        .clipShape(Cap5sule())
                }
                .frame(width: 30)
                Text(tag.wrappedName.replacingOccurrences(of: "#", with: ""))
                    .foregroundColor(selectedThemeColors.fontMainColour)
//                    .offset(x: 40, y: 3)
            

            .padding(3)
            
            .cornerRadius(3)
            
            
        }
            .frame(height: 30, alignment: .center)
//        .fixedSize()
        .onAppear(perform: {
            self.iconName = self.tag.icon ?? ""
        })
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        let tag = Tag(context: PersistenceController.preview.container.viewContext)
//        tag.icon = "person.3"
        TagView(tag: tag)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
    }
}
