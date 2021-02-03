//
//  PopupItemsList.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct PopupItemsList: View {
    @EnvironmentObject var modules: Modules
    @EnvironmentObject var selectedThemeColors: SelectedThemeColors
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    //debug only
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    var statusName: String
    @Binding var popupVisibility: Bool
    @State private var newMaxVolume = ""
    @State private var newMaxWeight = ""
    @State private var newMaxBattery = ""
    private let statusesThatCanModyfyMaxValue: [String] = ["volume", "weight", "battery"]
    private let statusesUnits: [String: String] = [
        "cost": "$",
        "volume": "㎤",
        "weight": "g",
        "battery": "%"
    ]
    
    private let popupWidth: CGFloat = 250
    private let popupHeight: CGFloat = 300
    
    func getStatusItemValue(item: Item) -> Int16 {
        switch self.statusName {
        case "volume":
            return item.volume
        case "weight":
            return item.weight
        case "cost":
            return item.cost
        case "battery":
            return item.batteryConsumption
        default:
            return item.batteryConsumption
        }
    }
    
    
    func sorterForWeight(firstItem: Item, secondItem: Item) -> Bool {
        return firstItem.weight > secondItem.weight
    }
    
    func sorterForVolume(firstItem: Item, secondItem: Item) -> Bool {
        return firstItem.volume > secondItem.volume
    }
    
    func sorterForCost(firstItem: Item, secondItem: Item) -> Bool {
        return firstItem.cost > secondItem.cost
    }
    
    func sorterForBatteryConsumption(firstItem: Item, secondItem: Item) -> Bool {
        return firstItem.batteryConsumption > secondItem.batteryConsumption
    }
       
    func getSorter() -> (Item, Item) -> Bool {
        
        switch self.statusName {
        case "volume":
            return self.sorterForVolume
        case "weight":
            return self.sorterForWeight
        case "cost":
            return self.sorterForCost
        case "battery":
            return self.sorterForBatteryConsumption
        default:
            return self.sorterForBatteryConsumption
        }
        
    }
    
    func getMaxValueVariable(statusName: String) -> Binding<String> {
        switch statusName {
        case "volume":
            return self.$newMaxVolume
        case "weight":
            return self.$newMaxWeight
        case "battery":
            return self.$newMaxBattery
        default:
            return self.$newMaxVolume
        }
    }
    
    func updateMaxValueForStatus(statusName: String) {
        switch statusName {
        case "volume":
            maxItemsInBagVolume = Int(self.newMaxVolume)!
        case "weight":
            maxItemsInBagWeight = Int(self.newMaxWeight)!
        case "battery":
            maxItemsInBagBatteryConsumption = Int(self.newMaxBattery)!
        default:
            maxItemsInBagVolume = Int(self.newMaxVolume)!
        }
    }
    
    
    var body: some View {
        VStack {
        
            
            Image(systemName: "xmark")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 20.0))
                .padding([.trailing, .bottom], 10)
                .onTapGesture {
                    self.popupVisibility = false
                }
            if statusesThatCanModyfyMaxValue.contains(self.statusName) {
                HStack(alignment: .center, spacing: 5) {
                    
                    TextField("Update max \(statusName)", text: self.getMaxValueVariable(statusName: statusName))
                        .foregroundColor(selectedThemeColors.fontSecondaryColour)
                        .background(selectedThemeColors.bgMainColour)
                        .cornerRadius(3)
                    .keyboardType(UIKeyboardType.decimalPad)
                    .padding([.leading, .trailing], 5)
                    
                    Spacer()
                    Button(action: {
                        self.updateMaxValueForStatus(statusName: self.statusName)
                    }) {
                        Text("Save")
                        .padding(5)
                            
                    }
                    .foregroundColor(selectedThemeColors.fontMainColour)
                    .background(selectedThemeColors.elementActiveColour)
                    .cornerRadius(3)
                }
                .padding([.leading, .trailing], 5)
            }
            
            List(self.items.filter({$0.isInBag == true}).sorted(by: self.getSorter())) {item in
                HStack {
                    Text(item.wrappedName)
                .frame(width: 125, alignment: .leading)
                
                    Text("\(self.getStatusItemValue(item: item)) \(self.statusesUnits[self.statusName]!)")
                .frame(width: 80, alignment: .trailing)
                }
                .onTapGesture {
                    self.modules.highlightedModule = item.name!
                }
            }
            
            if self.items.filter({$0.isInBag == true}).count < 4 {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Wanna buy some extra fancy stuff?")
                    .padding(5)
                }
                .foregroundColor(selectedThemeColors.fontMainColour)
                .background(selectedThemeColors.elementActiveColour)
                .cornerRadius(3)
                .padding(8)
            }
            
        }
        .padding(.top)
        .frame(width: self.popupWidth, height: self.popupHeight)
        .background(Color(red: 0.90, green: 0.9, blue: 0.95))
        .cornerRadius(10.0)
    }
}

struct PopupItemsList_Previews: PreviewProvider {
    static var previews: some View {
        PopupItemsList(statusName: "volume", popupVisibility: .constant(true))
    }
}
