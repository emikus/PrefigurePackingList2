//
//  TagView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 29/04/2021.
//

import SwiftUI
import SFSymbolsPicker

struct IconPickerTagPreview: View {
    var tag:Tag
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @State private var icon = ""
    @State var scaleImage : CGFloat = 1
    @State var iconName: String = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    func setNewIcon(iconName: String) -> Void {
        self.tag.icon = iconName
        try? viewContext.save()
    }
    
    var body: some View {
            HStack(alignment: .center){
                GeometryReader { geo in
                    Image(systemName: tag.icon != nil ? self.iconName : "person.3")
                        .frame(width: 30, height: 30)
                        .foregroundColor(tag.iconCategoryColor)
                        .scaleEffect(self.scaleImage)
                        .animation(.easeInOut)
                        .onChange(of: tag.icon, perform: { value in
                            self.scaleImage = 0.01
                            
                            withAnimation(Animation.spring().delay(0.5)) {
                                print(value!)
                                self.iconName = value!
                                self.scaleImage = 1
                            }
                        })
                        .cornerRadius(5)
                }
                .frame(width: 30, height: 30)
                Text(tag.wrappedName.replacingOccurrences(of: "#", with: ""))
                    .foregroundColor(.black.opacity(0.8))
            
            .cornerRadius(3)
        }
            .frame(height: 25, alignment: .center)
            .padding(3)
            .padding(.trailing, 3)
            .border(tag.iconCategoryColor, width: 3)
            .cornerRadius(5)
//        .fixedSize()
        .onAppear(perform: {
            self.iconName = self.tag.icon ?? ""
        })
    }
}

struct IconPickerTagPreview_Previews: PreviewProvider {
    static var previews: some View {
        let tag = Tag(context: PersistenceController.preview.container.viewContext)
//        tag.icon = "person.3"
        IconPickerTagPreview(tag: tag)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(SelectedThemeColors())
    }
}
