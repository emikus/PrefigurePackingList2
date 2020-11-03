//
//  ItemListView.swift
//  PPL
//
//  Created by Macbook Pro on 12/10/2020.
//

import SwiftUI

struct ItemListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var modules: Modules
    @EnvironmentObject var dataFacade: DataFacade
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingSelectedActivityItemRemovalAlert = false
    @State private var showingExceedingWeightAlert = false
    @State private var showingExceedingVolumeAlert = false
    @ObservedObject var item: Item
    @State var showAddEditItemView = false
    
    
    var body: some View {
        HStack(alignment: .center) {
            Text(item.symbol ?? "symbol itema")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(item.wrappedName)
                    .foregroundColor(.white)

            }
            .frame(width: 120, alignment: .leading)
            .alert(isPresented: $showingExceedingVolumeAlert) {
                Alert(title: Text("You will not be able to zip your bag, sorry :)"), message: Text("Remove sth wisely before adding this item"), primaryButton: .default(Text("Send me a bigger bag :)")), secondaryButton: .cancel())
            }

            Spacer()

            VStack(alignment: .leading) {

                Text("Weight: \(item.weight)g" )
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Volume: \(self.item.volume)㎤")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Battery: \(self.item.batteryConsumption)%")
                .font(.caption)
                .foregroundColor(.gray)
            }
            .frame(width: 120, alignment: .leading)
            .alert(isPresented: $showingExceedingVolumeAlert) {
                Alert(title: Text("You will not be able to zip your bag, sorry :)"), message: Text("Remove sth wisely before adding this item"), primaryButton: .default(Text("Send me a bigger bag :)")), secondaryButton: .cancel())
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Available slot:")
                .font(.caption)
                .foregroundColor(.gray)
                Text(item.moduleSymbol ?? "item module symbol")
                    .frame(width: 20)
                    .opacity(self.modules.freeModulesSlots[item.moduleSymbol ?? ""] != nil ? 1 : 0.1)
                    .alert(isPresented: $showingExceedingWeightAlert) {
                        Alert(title: Text("You will have to carry more than 10 kg 💪"), message: Text("Will you manage to do it?"), primaryButton: .default((Text("A. Schwarzenegger is my father"))) {
                            self.item.isInBag = true
                            self.modules.addRemoveItemToModule(item: self.item)
                            }, secondaryButton: .cancel())
                }
            }
            .frame(width: 180.0, alignment: .leading)
            Spacer()
            VStack(alignment: .leading) {
                Text("Activities:")
                .font(.caption)
                .foregroundColor(.gray)
                HStack {
                    ForEach (activities.filter({$0.itemArray.contains(item)}), id: \.self)  { itemActivity in
//
                        Image(systemName: itemActivity.symbol!)
                            .foregroundColor( itemActivity.isSelected ? .green : .gray)
                }
                }
            }
            .frame(width: 180.0, alignment: .leading)
            .alert(isPresented: $showingSelectedActivityItemRemovalAlert) {
                        Alert(title: Text("This item belongs to the activity you've selected before. Are you sure you want to delete it from your bag?"), message: Text("You can always add it back"), primaryButton: .destructive(Text("Delete")) {
                            self.item.isInBag = false
                            self.modules.addRemoveItemToModule(item: self.item)
                            }, secondaryButton: .cancel())
                    }

            Spacer()

            Image(systemName: "bag")
                .foregroundColor(self.items.filter({$0.isInBag == true}).contains(item) ? /*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/ : .white)
        }
            .background(Color(red: 28/255, green: 29/255, blue: 31/255))
        .contentShape(Rectangle())
        .onTapGesture {
            let addingItemWillExceedWeight = Int(self.item.weight) + self.dataFacade.getItemsInBagWeight(itemsInBag: self.items.filter({$0.isInBag==true})) > maxItemsInBagWeight

            let addingItemWillExceedVolume = Int(self.item.volume) + self.dataFacade.getItemsInBagVolume(itemsInBag: self.items.filter({$0.isInBag==true})) > maxItemsInBagVolume

            if self.dataFacade.checkIfItemActivitiesAreSelected(item: self.item) && self.items.filter({$0.isInBag == true}).contains(self.item) {
                self.showingSelectedActivityItemRemovalAlert = true
            } else if self.dataFacade.checkIfItemActivitiesAreSelected(item: self.item) && self.items.filter({$0.isInBag == true}).contains(self.item) {
                self.showingSelectedActivityItemRemovalAlert = true
            } else if addingItemWillExceedVolume && !self.items.filter({$0.isInBag == true}).contains(self.item) {
                self.showingExceedingVolumeAlert = true
            } else if addingItemWillExceedWeight && !self.items.filter({$0.isInBag == true}).contains(self.item) {
                self.showingExceedingWeightAlert = true
            } else {
                self.item.isInBag.toggle()
                self.modules.addRemoveItemToModule(item: self.item)
            }
        }
        .onDrag {
            dNdSourceView = .itemsList
            return NSItemProvider(object: self.item)
        }
        .contextMenu{
                Button(action: {
                    self.dataFacade.pinUnpinItem(item: self.item)
                }) {
                    Text(self.item.isPinned == false ? "Pin to the top" : "Unpin this item")
                    Image(systemName: self.item.isPinned == false ? "pin" : "pin.slash")
                        .font(.system(size: 16, weight: .ultraLight))
                }

                Button(action: {
                    self.showAddEditItemView.toggle()

                }) {
                    Text("Edit \(self.item.wrappedName)")
                    Image(systemName: "square.and.pencil")
                }

                Button(action: {
//                    self.items.addRemoveItemFromTheShelf(item: self.item)
                }) {
//                    Text(self.items.itemsInTheShelf.contains(self.item) ? "Remove from the shelf" : "Add to the shelf")
//                    Image(systemName: self.items.items.contains(self.item) ? "books.vertical" : "books.vertical")
//                        .font(.system(size: 16, weight: .ultraLight))
                }

                Button(action: {
                    self.dataFacade.removeItem(item: self.item)
                }) {
                    Text("Delete item")
                    Image(systemName: "trash")
                        .font(.system(size: CGFloat(10), weight: .ultraLight))
                }
        }
        .sheet(isPresented: self.$showAddEditItemView) {
            AddEditItem(item: self.item)
        }
    }
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemListView()
//    }
//}
