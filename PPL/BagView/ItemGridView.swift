//
//  ItemGridView.swift
//  PPL
//
//  Created by Macbook Pro on 13/10/2020.
//


import SwiftUI

struct ItemGridView: View {
    @Environment(\.managedObjectContext) private var viewContext
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
    @State private var showingSelectedActivityItemRemovalAlert = false
    @State private var showingExceedingWeightAlert = false
    @State private var showingExceedingVolumeAlert = false
    @ObservedObject var item: Item
    @State var showAddEditItemView = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(item.wrappedModuleSymbol)
                    .frame(width: 20)
                    .opacity(self.modules.freeModulesSlots[item.wrappedModuleSymbol] != nil ? 1 : 0.1)
                    .alert(isPresented: $showingExceedingWeightAlert) {
                        Alert(title: Text("You will have to carry more than 10 kg 💪"), message: Text("Will you manage to do it?"), primaryButton: .default((Text("A. Schwarzenegger is my father"))) {
                            self.item.isInBag = true
                            self.modules.addRemoveItemToModule(item: self.item)
                            }, secondaryButton: .cancel())
                }
                Spacer()
                Image(systemName: "bag")
                    .foregroundColor(self.item.isInBag ? /*@START_MENU_TOKEN@*/elementActiveColour/*@END_MENU_TOKEN@*/ : Color(red: 100/255, green: 100/255, blue: 100/255))
                .offset(x: 0, y: -2)
            }
            .padding(.trailing, 5.0)
            
            Spacer()
            VStack(alignment: .leading) {
                
                Text(item.wrappedName)
                    .font(.headline)
                    .foregroundColor(fontMainColour)
                
                
                
                Text("Weight: \(item.weight) g" )
                    .font(.caption)
                    .foregroundColor(Color(red: 138/255, green: 139/255, blue: 141/255))
                Text("Volume: \(self.item.volume) ㎤")
                    .font(.caption)
                    .foregroundColor(fontSecondaryColour)
            }
            .alert(isPresented: $showingExceedingVolumeAlert) {
                Alert(title: Text("You will not be able to zip your bag, sorry :)"), message: Text("Remove sth wisely before adding this item"), primaryButton: .default(Text("Send me a bigger bag :)")), secondaryButton: .cancel())
            }
            
            
            //show item's categories only if an item belongs to the user
            
                HStack {
                    ForEach (activities.filter({$0.itemArray.contains(item)}), id: \.self)  { itemActivity in
//
                        Image(systemName: itemActivity.symbol!)
                            .foregroundColor( itemActivity.isSelected ? elementActiveColour : fontSecondaryColour)
                }
                }                .padding(.bottom, 10.0)
                    
                .alert(isPresented: $showingSelectedActivityItemRemovalAlert) {
                    Alert(title: Text("This item belongs to the activity you've selected before. Are you sure you want to delete it from your bag?"), message: Text("You can always add it back"), primaryButton: .destructive(Text("Delete")) {
                        self.item.isInBag = false
                        self.modules.addRemoveItemToModule(item: self.item)
                        }, secondaryButton: .cancel())
                }
                
            
            
            Spacer()
        }
        .frame(width: 100, height: 110)
//        .opacity(1)
        .padding([.top], 10.0)
        .padding([.leading], 3.0)
        .background(bgSecondaryColour)
//        .border(self.items.itemsInBag.contains(item) ? Color/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/ : Color.red, width: 1)
        .cornerRadius(10)
        .contentShape(Rectangle())
//        .border(Color.gray, width: 1)
        .onTapGesture {
            let addingItemWillExceedWeight = Int(self.item.weight) + self.dataFacade.getItemsInBagWeight(itemsInBag: self.items.filter({$0.isInBag==true})) > maxItemsInBagWeight

            let addingItemWillExceedVolume = Int(self.item.volume) + self.dataFacade.getItemsInBagVolume(itemsInBag: self.items.filter({$0.isInBag==true})) > maxItemsInBagVolume

            if self.dataFacade.checkIfItemActivitiesAreSelected(item: self.item) && self.item.isInBag == true {
                self.showingSelectedActivityItemRemovalAlert = true
            } else if self.dataFacade.checkIfItemActivitiesAreSelected(item: self.item) && self.item.isInBag == true {
                self.showingSelectedActivityItemRemovalAlert = true
            } else if addingItemWillExceedVolume && self.item.isInBag == false {
                self.showingExceedingVolumeAlert = true
            } else if addingItemWillExceedWeight && self.item.isInBag == false {
                self.showingExceedingWeightAlert = true
            } else {
                self.item.isInBag.toggle()
                self.modules.addRemoveItemToModule(item: self.item)
            }
        }
        
        .onDrag {
            dNdSourceView = .itemsList
            let draggedItem = NSItemProvider(item: .some(String("dupa") as NSSecureCoding), typeIdentifier: String("ppl.ite"))
            return draggedItem
        }
        
        .contextMenu {
            Button(action: {
                self.showAddEditItemView.toggle()
//                self.items.addRemoveItemFromTheShelf(item: self.item)
            }) {
                Text("Add to the shelf")
//                Text(self.items.itemsInTheShelf.contains(item) ? "Remove from the shelf" : "Add to the shelf")
//                Image(systemName: self.items.items.contains(item) ? "books.vertical" : "books.vertical")
//                    .font(.system(size: 16, weight: .ultraLight))
            }
            
            Button(action: {
                self.showAddEditItemView.toggle()
            }) {
                Text("Edit \(item.wrappedName)")
                Image(systemName: "square.and.pencil")
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
//                // .preferredColorScheme(.light)
        
        
    }

}

struct ItemGridView_Previews: PreviewProvider {
        
    static var previews: some View {
        let item = Item(context: PersistenceController.preview.container.viewContext)
        
        ItemGridView(item: item)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(Modules())
    }
}
