//
//  ProgressBarView.swift
//  PPL
//
//  Created by Macbook Pro on 10/10/2020.
//


import SwiftUI

struct ProgressBarView: View {
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    @State private var progressBarWidth = CGFloat(25)
    @State private var progressBarHeight = CGFloat(10)
    @State var progressBarValue: String

    
    func getItemsInBagWeight () -> Int {
        var itemsInBagWeight = 1
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagWeight += Int(item.weight)
        }
        
        return itemsInBagWeight
    }
    
    func getItemsInBagVolume () -> Int {
        var itemsInBagVolume = 1
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagVolume += Int(item.volume)
        }
        
        return itemsInBagVolume
    }
    
    func getItemsInBagBatteryConsumption () -> Int {
        var itemsInBatteryConsumption = 1
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBatteryConsumption += Int(item.batteryConsumption)
        }
        
        return itemsInBatteryConsumption
    }

    
    func getItemsInBagCost () -> Int {
        var itemsInBagCost = 1
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagCost += Int(item.cost)
        }
        
        return itemsInBagCost
    }
    
    
    func getProgressBarColor() -> UIColor {
        
        let currentBarLength:Int
        
        
        switch self.progressBarValue {
        case "weight":
            currentBarLength = (getItemsInBagWeight() * 50) / maxItemsInBagWeight
        case "volume":
            currentBarLength = (getItemsInBagVolume() * 50) / maxItemsInBagVolume
        case "battery":
            currentBarLength = 20
            
        
        default:
            currentBarLength = (getItemsInBagWeight() * 50) / maxItemsInBagWeight
        }
        
        switch currentBarLength {
        case 0...34:
            return .green
        case 35...45:
            return .yellow
        case 46...50:
            return .red
        default:
            return .red
        }
    }
    
    func itemsInBagVolume () -> Int {
        var itemsInBagVolume = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagVolume += Int(item.volume)
            
            
        }
        self.items[0].volume = 5
        self.items[1].volume = 13
        
        self.items[0].weight = 95
        self.items[1].weight = 130
        
        self.items[0].batteryConsumption = 50
        self.items[1].batteryConsumption = 70
        
        return itemsInBagVolume
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
//                Text(String(self.itemsInBagVolume()))
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(width: self.progressBarHeight, height: self.progressBarWidth)
                        .cornerRadius(2)
                    
                    if self.progressBarValue == "weight" {
                        
                        Color(self.getProgressBarColor())
                            .frame(width: self.progressBarHeight, height: self.getItemsInBagWeight() * Int(self.progressBarWidth) / maxItemsInBagWeight < Int(self.progressBarWidth) ? CGFloat(self.self.getItemsInBagWeight() * Int(self.progressBarWidth) / maxItemsInBagWeight) : CGFloat(self.progressBarWidth))
                            .cornerRadius(2)
                            .animation(.easeInOut)
                    }
                    
                    if self.progressBarValue == "volume" {
                        
                        Color(self.getProgressBarColor())
                            .frame(width: self.progressBarHeight, height: self.getItemsInBagVolume() * Int(self.progressBarWidth) / maxItemsInBagVolume < Int(self.progressBarWidth) ? CGFloat(self.getItemsInBagVolume() * Int(self.progressBarWidth) / maxItemsInBagVolume) : CGFloat(self.progressBarWidth))
                            .cornerRadius(2)
                            .animation(.easeInOut)
                    }
                    
                    
                    if self.progressBarValue == "batteryConsumption" {
                        
                        Color(self.getProgressBarColor())
                            .frame(width: self.progressBarHeight, height:  self.getItemsInBagBatteryConsumption() * Int(self.progressBarWidth) / maxItemsInBagBatteryConsumption < Int(self.progressBarWidth) ? CGFloat(self.getItemsInBagBatteryConsumption() * Int(self.progressBarWidth) / maxItemsInBagBatteryConsumption) : CGFloat(self.progressBarWidth))
                            .cornerRadius(2)
                            .animation(.easeInOut)
                    }
                }
            }
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(progressBarValue: "batteryConsumption")
    }
}
