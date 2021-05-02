//
//  TagView.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 29/04/2021.
//

import SwiftUI

struct TagView: View {
    var tag:Tag
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
    var body: some View {
        HStack{
            Image(systemName: tag.wrappedIcon)
                .foregroundColor(selectedThemeColors.fontMainColour)
            Text(tag.wrappedName.replacingOccurrences(of: "#", with: ""))
                .foregroundColor(selectedThemeColors.buttonMainColour)
                .offset(x: -5, y: 0)
        }
        
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
