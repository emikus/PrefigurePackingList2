//
//  ModulesAndShelvesView.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct ModulesAndShelvesView: View {
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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \BagContentSet.date, ascending: false)],
        animation: .default)
    private var bagContentSets: FetchedResults<BagContentSet>
    
    
    @EnvironmentObject var modules: Modules
    @State var isDragging = false
    @State var upperPanelHeight = 190.0
    @State var showAddEditItem = false
    @State var showAddBagContentSet = false
    @State var showBagContentSets = false
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                let screenHeightPixelsNumber = Double(UIScreen.main.bounds.height)
                
                if self.upperPanelHeight + Double(CGFloat(value.translation.height)) <= screenHeightPixelsNumber && self.upperPanelHeight + Double(CGFloat(value.translation.height)) >= 0 {
                   self.upperPanelHeight += Double(CGFloat(value.translation.height))
                }
                self.isDragging = true
            }
            .onEnded { value in
                self.isDragging = false
                let screenHeightPixelsNumber = Double(UIScreen.main.bounds.height)
                let fullSizeSecondPanelThreshold = (screenHeightPixelsNumber + 190) / 2

                if self.upperPanelHeight >= 0 && self.upperPanelHeight <= 95 {
                    self.upperPanelHeight = Double(CGFloat(0))
                } else if self.upperPanelHeight > 95 && self.upperPanelHeight < fullSizeSecondPanelThreshold {
                    self.upperPanelHeight = Double(CGFloat(190))
                } else {
                    self.upperPanelHeight = screenHeightPixelsNumber
                }
            }
    }
    
    
    
    var body: some View {
        VStack {
            Text("Squash wit Kim will start in \(Date().addingTimeInterval(600), style: .timer)")
//            
            GeometryReader { geometry in
                VStack {
                    HStack(alignment: .top) {
                        Text("")
                            .frame(width: geometry.size.width / 6 - 10, alignment: .center)
                        VStack {
                            StandGraphicView()
                        }
                        .frame(width: geometry.size.width * 4/6)
                        
                        VStack {
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        self.items.filter({$0.isInBag == true}).forEach { item in
                                            item.isInBag = false
                                            self.modules.addRemoveItemToModule(item: item)
                                        }
                                        
                                        self.activities.filter({$0.isSelected == true}).forEach { activity in
                                            activity.isSelected = false
                                        }
                                        
                                    }) {
                                        Image(systemName: "bag.badge.minus")
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .keyboardShortcut(KeyEquivalent("e"))
                                    
                                    Button(action: {
                                        self.showAddEditItem.toggle()
                                    }) {
                                        Image(systemName: "plus")
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .keyboardShortcut(KeyEquivalent("n"))
                                    .sheet(isPresented: self.$showAddEditItem) {
                                        AddEditItem()
                                            .environment(\.managedObjectContext, self.viewContext)
                                    }
                                    
                                    Button(action: {
                                        self.showAddBagContentSet.toggle()
                                    }) {
                                        Image(systemName: "square.and.arrow.down")
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .keyboardShortcut(KeyEquivalent("s"))
                                    .disabled(self.items.filter({$0.isInBag == true}).count == 0)
                                    .sheet(isPresented: self.$showAddBagContentSet) {
                                        SaveBagContentSetView()
                                        .environmentObject(self.modules)
                                    }
                                    
                                    Button(action: {
                                        
//                                        self.saveBagContentSet()
                                        self.showBagContentSets.toggle()
                                    }) {
                                        Image(systemName: "list.triangle")
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .keyboardShortcut(KeyEquivalent("l"))
                                    .disabled(bagContentSets.count < 1)
                                    .sheet(isPresented: self.$showBagContentSets) {
                                        BagContentSetsListView()
                                    }
                                    
                                    
                                    
                                }
                                
                            }
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width / 6 - 10, alignment: .center)
                    }
                    .frame(height: CGFloat(self.upperPanelHeight > 190 ? 190 : self.upperPanelHeight))
                    Spacer()
                }
                .frame(width: geometry.size.width, height: CGFloat(self.upperPanelHeight + 40))
                .offset(x: 0, y: self.upperPanelHeight > 0 ? 0 : -250)
                
            }
            
            Spacer()
            Image(systemName: "minus")
                .padding()
                .font(.system(size: 40, weight: .semibold))
                .foregroundColor(.gray)
                .contentShape(Rectangle())
                .gesture(self.drag)
        }
        .frame(height: CGFloat(self.upperPanelHeight + 35))
        .background(Color(red: 20/255, green: 20/255, blue: 20/255))
        .animation(self.isDragging ? .none : .easeInOut)
        
    }
}

struct ModulesAndShelvesView_Previews: PreviewProvider {
    static var previews: some View {
        ModulesAndShelvesView()
            .previewDevice("iPad Pro (9.7-inch)")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(Modules())
    }
}
