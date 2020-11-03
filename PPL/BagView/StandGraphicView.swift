//
//  StandGraphicView.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct StandGraphicView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var modules: Modules
    @State var strapOneFlipped: Bool = false
    @State var strapTwoFlipped: Bool = false
    @State var standMessengerModeFlipped: Bool = false
    @State var standBookModeFlipped: Bool = false
    
    
    var body: some View {
        let strapOneFlipDegrees = strapOneFlipped ? 180.0 : 0
        let strapTwoFlipDegrees = strapTwoFlipped ? 180.0 : 0
        let standMessengerModeFlipDegrees = standMessengerModeFlipped ? 180.0 : 0
        let standBookModeFlipDegrees = standBookModeFlipped ? 180.0 : 0
        let strapWidthDivider = CGFloat(6)
        
        return GeometryReader { geometry in
            HStack {
                ZStack {
                    
                    ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.strapOneFrontModulesOccupation)
                        .flipRotate(strapOneFlipDegrees)
                        .opacity(self.strapOneFlipped ? 0.0 : 1.0)
                    
                    ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.strapOneBackModulesOccupation)
                        .flipRotate(-180 + strapOneFlipDegrees)
                        .opacity(self.strapOneFlipped ? 1.0 : 0.0)
                    
                }
                .frame(width: geometry.size.width/strapWidthDivider)
                .animation(.easeInOut(duration: 0.8))
                .onTapGesture { print(geometry.size)
                    self.strapOneFlipped.toggle() }
                
                TabView {
                    ZStack {
                        ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.standMessengerModeModulesFrontOccupation)
                            .flipRotate(standMessengerModeFlipDegrees)
                            .opacity(self.standMessengerModeFlipped ? 0.0 : 1.0)
                        ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.standMessengerModeModulesBackOccupation)
                            .flipRotate(-180 + standMessengerModeFlipDegrees)
                            .opacity(self.standMessengerModeFlipped ? 1.0 : 0.0)
                    }
                    
                    .animation(.easeInOut(duration: 0.8))
                    .onTapGesture { print(geometry.size)
                        self.standMessengerModeFlipped.toggle() }
                    
                    
                    ZStack {
                        ModulesGridView(numberOfColumns: 6, modulesSet: self.modules.standBookModeModulesFrontOccupation)
                            .flipRotate(standMessengerModeFlipDegrees)
                            .opacity(self.standBookModeFlipped ? 0.0 : 1.0)
                        ModulesGridView(numberOfColumns: 6, modulesSet: self.modules.standBookModeModulesBackOccupation)
                            .flipRotate(-180 + standBookModeFlipDegrees)
                            .opacity(self.standBookModeFlipped ? 1.0 : 0.0)
                    }
                    .animation(.easeInOut(duration: 0.8))
                    .onTapGesture { print(geometry.size)
                        self.standBookModeFlipped.toggle() }
                }
                .frame(width: geometry.size.width*(4/6) - 15)
                .tabViewStyle(PageTabViewStyle())
                
                ZStack {
                    ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.strapTwoFrontModulesOccupation)
                        .flipRotate(strapTwoFlipDegrees)
                        .opacity(self.strapTwoFlipped ? 0.0 : 1.0)
                    
                    ModulesGridView(numberOfColumns: 2, modulesSet: self.modules.strapTwoBackModulesOccupation)
                        .flipRotate(-180 + strapTwoFlipDegrees)
                        .opacity(self.strapTwoFlipped ? 1.0 : 0.0)
                    
                }
                .frame(width: geometry.size.width/strapWidthDivider)
                .animation(.easeInOut(duration: 0.8))
                .onTapGesture { print(geometry.size)
                    self.strapTwoFlipped.toggle() }
                
            }
            .onDrop(of: ["ppl.ite"], isTargeted: nil) { ips in
                if let ip = ips.first {
                    ip.loadObject(ofClass: Item.self) { reading, _ in
                        guard let item = reading as? Item else { return }
                        DispatchQueue.main.async {
                            let originalItem = self.items.filter{ $0.id == item.id }.first!
                            
                            if !self.items.filter({$0.isInBag==true}).contains(originalItem) {
                                originalItem.isInBag = true
                                self.modules.addRemoveItemToModule(item: originalItem)
                            }
                        }
                    }
                }
                return true
                
            }
        }
        .zIndex(1000)
    }
}

struct StandGraphicView_Previews: PreviewProvider {
    static var previews: some View {
        StandGraphicView()
    }
}
