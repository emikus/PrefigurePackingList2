//
//  ActivityView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

func sampleActivity() -> Activity {
    let activity = Activity()
    activity.name = "sample"
    activity.duration = 74
    activity.symbol = "sheet"
    activity.category = "general"
    activity.id = UUID()
    
    return activity
}

struct ActivityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var dataFacade: DataFacade
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    var activity: Activity
    @Binding var expandedActivityId: UUID
    @State var showAddEditActivityView:Bool = false
    
    
    
    
    var body: some View {
        
        VStack {
            HStack(alignment: .center) {
                Image(systemName: "\(activity.wrappedSymbol)")
                Text(activity.wrappedName)
                Text(activity.durationInHoursAndMinutes)
                .font(.caption)
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundColor(self.activity.isSelected ? selectedThemeColors.elementActiveColour : selectedThemeColors.fontSecondaryColour)
            }
            
            if (activity.id == expandedActivityId) {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(activity.itemArray, id: \.id) {activityItem in
                        Text("\(activityItem.wrappedName): 𐄷\(activityItem.weight)g ䷰\(activityItem.volume)㎤")
                        .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25.0)
                        
                    }
                }
            }
            
        }
        .foregroundColor(selectedThemeColors.fontMainColour)
         .background(selectedThemeColors.bgMainColour)
        .opacity(0.8)
        .contentShape(Rectangle())
        .contextMenu {
            Button(action: {
                self.dataFacade.pinUnpinActivity(activity: self.activity)
            }) {
                Text(self.activity.isPinned == true ? "Unpin this activity" : "Pin to the top")
                Image(systemName: self.activity.isPinned ? "pin.slash" : "pin")
                    .font(.system(size: 16, weight: .ultraLight))
            }

            
            Button(action: {
                self.showAddEditActivityView.toggle()
            }) {
                Text("Edit \(activity.wrappedName)")
                Image(systemName: "square.and.pencil")
                .font(.system(size: CGFloat(10), weight: .ultraLight))
            }
            
            Button(action: {
                self.dataFacade.removeActivity(activity: self.activity)
                
            }) {
                Text("Delete \(activity.wrappedName) from the list")
                Image(systemName: "trash")
                .font(.system(size: CGFloat(10), weight: .ultraLight))
            }
        }
        .onTapGesture {
            print(self.activity.isSelected)
            self.expandedActivityId = self.activity.id!
            self.dataFacade.selectDeselectActivity(activity: self.activity)
        }
        .sheet(isPresented: self.$showAddEditActivityView) {
            AddEditActivityView(activity: self.activity)
                        
        }
        
    }
    
}

struct ActivityView_Previews: PreviewProvider {
    
    static var previews: some View {
        let activity = Activity(context: PersistenceController.preview.container.viewContext)
        
        ActivityView(activity: activity, expandedActivityId: .constant(UUID()))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
