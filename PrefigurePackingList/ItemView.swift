//
//  ItemView.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 02/08/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var items: Items
    @EnvironmentObject var activities: Activities
    @State private var showingSelectedActivityItemRemovalAlert = false
    @ObservedObject var item: Item
    
    
    
    var body: some View {
        HStack(alignment: .center) {
            
            
            
            VStack(alignment: .leading) {
                Text(item.name)
                Text("Weight: \(item.weight)g" )
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Volume: \(self.item.volumeWithUnit.value,  specifier: "%.0f")㎤")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            HStack() {
                ForEach (Array(self.items.itemsActivitySymbols[self.item.id]!.keys), id: \.self)  { itemActivitySymbol in
                    
                    Image(systemName:self.items.itemsActivitySymbols[self.item.id]![itemActivitySymbol]!)
                        .foregroundColor(self.activities.selectedActivities.contains{ $0.id == itemActivitySymbol } ? .green : .gray)
                    
                }
            }
            .frame(width: 120.0, alignment: .trailing)
            
            
            
            
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .foregroundColor(self.items.itemsInBag.contains(item) ? /*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/ : .white)
            
        }
        .opacity(0.8)
        .contentShape(Rectangle())
        .onTapGesture {
            
            if self.checkIfItemActivitiesAreSelected() && self.items.itemsInBag.contains(self.item) {
                self.showingSelectedActivityItemRemovalAlert = true
            } else {
                self.addRemoveItemToBag()
            }
            
        }
        .alert(isPresented: $showingSelectedActivityItemRemovalAlert) {
            Alert(title: Text("This item belongs to the activity you've selected before. Are you sure you want to delete it from your bag?"), message: Text("You can always add it back"), primaryButton: .destructive(Text("Delete")) {
                self.addRemoveItemToBag()
                }, secondaryButton: .cancel())
        }
        .contextMenu {
            Button(action: {
                self.pinUnpinItem()
            }) {
                Text(self.items.items.contains(self.item) ? "Pin to the top" : "Unpin this item")
                Image(systemName: self.items.items.contains(self.item) ? "pin" : "pin.slash")
                    .font(.system(size: 16, weight: .ultraLight))
            }
            
            NavigationLink(destination: AddEditItem(item: self.item)) {
                Text("Edit \(self.item.name)")
                Image(systemName: "square.and.pencil")
            }
            
            Button(action: {
                // enable geolocation
                self.removeItemFromTheList()
                self.removeItemFromBag()
                
            }) {
                Text("Delete from the list")
                Image(systemName: "trash")
                    .font(.system(size: CGFloat(10), weight: .ultraLight))
            }
        }
    }
    
    func checkIfItemActivitiesAreSelected() -> Bool {
        let selectedActivitiesContainItem = self.activities.selectedActivities.contains{ $0.items.contains(self.item)}
        
        return selectedActivitiesContainItem
    }
    
    
    func addRemoveItemToBag() {
        if !self.items.itemsInBag.contains(self.item) {
            self.items.itemsInBag.append(self.item)
        } else {
            self.items.itemsInBag.removeAll {$0 == self.item}
        }
    }
    
    func removeItemFromBag() {
        self.items.itemsInBag.removeAll {$0 == self.item}
    }
    
    func removeItemFromTheList() {
        self.items.items.removeAll {$0 == self.item}
        self.items.itemsPinned.removeAll {$0 == self.item}
    }

    func pinUnpinItem() {
        if !self.items.itemsPinned.contains(self.item) {
            self.items.itemsPinned.insert(self.item, at: 0)
            self.items.items.removeAll {$0 == self.item}
        } else {
            self.items.itemsPinned.removeAll {$0 == self.item}
            self.items.items.insert(self.item, at: 0)
        }
    }
    
    
}

struct ItemView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ItemView(item: sampleItems[0])
            .environmentObject(Items(fillWithSampleData: true))
            .environmentObject(Activities())
    }
}
