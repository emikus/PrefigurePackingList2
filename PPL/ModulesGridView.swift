//
//  ModulesGridView.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct ModulesGridView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var modules: Modules
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    
    @State var isDragging = false
    @GestureState var dragAmount = CGSize.zero
    @State var itemsZIndexes: [String: Double] = [:]
    var numberOfColumns: Int
    var modulesSet: [String: String]
    var modulestSetGridArray: [[String]]
    var numberOfRows = 0
    
    init(numberOfColumns: Int, modulesSet: [String: String]) {
        
        self.numberOfColumns = numberOfColumns
        self.modulesSet = modulesSet
        self.modulestSetGridArray = []
        
        self.numberOfRows = Int(ceil(Double(modulesSet.count) / Double(numberOfColumns)))
        let lastIterationNumber = self.numberOfRows - 1
        
        let modulesArray:[String] = Array(self.modulesSet.keys)
        
        for n in 0...lastIterationNumber {
            let startIndex = n * self.numberOfColumns
            
            let endIndex = n == lastIterationNumber ? modulesArray.count - 1 : startIndex + self.numberOfColumns - 1
            
            self.modulestSetGridArray.insert(Array(modulesArray[startIndex...endIndex]), at: n)
        }
        
    }

    func getItemIcon(moduleSymbol: String, viewWidth: Int) -> String {
        return (viewWidth < 200 ? self.items.filter({$0.name == self.modulesSet[moduleSymbol]})[0].symbol : self.modulesSet[moduleSymbol])!
    }
    
    var body: some View {
        
        return GeometryReader { geometry in
            VStack {
                ForEach(self.modulestSetGridArray, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(row, id: \.self) { moduleSymbol in
                            ZStack {
                                VStack(spacing: 0) {
                                    Text(moduleSymbol)
                                        .font(.system(size: self.modulesSet[moduleSymbol] != "" ? geometry.size.height/10 : geometry.size.height/12))
                                    
                                    if self.modulesSet[moduleSymbol] != "" {
                                        Text(self.getItemIcon(moduleSymbol: moduleSymbol, viewWidth: Int(geometry.size.width)))
                                            .font(.system(size: geometry.size.height/7))
                                            .opacity(0.7)
                                            .offset(self.dragAmount)
                                            .onDrag {
//                                                dndSourceView = .modules
                                                
                                                let item = self.items.filter({$0.name == self.modulesSet[moduleSymbol]})[0]
                                                
                                                return NSItemProvider(object: item)
                                        }
                                    }
                                }
                                
                                Circle()
                                    .frame(width: 10)
                                    .foregroundColor(self.modulesSet[moduleSymbol] == "" ? .green : .red)
                                    .offset(x: -geometry.size.width/CGFloat(self.numberOfColumns)/2 + 10 , y: -geometry.size.height/CGFloat(self.numberOfRows)/2 + 12)
                            }
                            .frame(width: geometry.size.width/CGFloat(self.numberOfColumns) - 2, height: geometry.size.height/CGFloat(self.numberOfRows + 0) - 6)
                                .background(self.modulesSet[moduleSymbol] != "" && self.modulesSet[moduleSymbol] == self.modules.highlightedModule ? Color.orange : selectedThemeColors.bgSecondaryColour)
                                .cornerRadius(10)
                            
                            
                        }
                    }
                }
            }
            .foregroundColor(selectedThemeColors.fontMainColour)
        }
    }
}

struct ModulesGridView_Previews: PreviewProvider {
    static var previews: some View {
        ModulesGridView(numberOfColumns: 4, modulesSet: sampleModules)
        .environmentObject(Modules())
    }
}
