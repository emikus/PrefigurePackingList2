//
//  VolumeWeightDurationIndicatorsView.swift.swift
//  PPL
//
//  Created by Macbook Pro on 11/10/2020.
//

import SwiftUI

struct VolumeWeightDurationIndicatorsView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.name, ascending: true)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
            animation: .default)
    private var items: FetchedResults<Item>
    
    private let viewHeight: CGFloat = 30
    private let popupWidth: CGFloat = 250
    private let popupHeight: CGFloat = 300
    
    @State private var selectedActivitiesPopupVisible = false
    @State private var costPopupVisible = false
    @State private var volumePopupVisible = false
    @State private var weightPopupVisible = false
    @State private var batteryConsumptionPopupVisible = false
    @State private var newMaxVolume = ""
    @State private var newMaxWeight = ""
    @State private var newMaxBattery = ""
    @GestureState private var isDown = false
    
//    private let sorters: [Func] = [self.sorterForWeight]

    
    
    func hideAllVisiblePopups() {
        self.selectedActivitiesPopupVisible = false
        self.costPopupVisible = false
        self.volumePopupVisible = false
        self.weightPopupVisible = false
        self.batteryConsumptionPopupVisible = false
    }
    
    func handlePressing(_ isPressed: Bool) {
        guard !isPressed else { return }
        //MARK: - handle if unpressed
        self.hideAllVisiblePopups()
    }
    
    func sorterForWeight(firstItem: Item, secondItem: Item) -> Bool {
      return firstItem.weight > secondItem.weight
    }
    
    func getSorter(sorterName: String) -> (Item, Item) -> Bool {
        return self.sorterForWeight
    }
    
    func getItemsInBagWeight () -> Int {
        var itemsInBagWeight = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagWeight += Int(item.weight)
        }
        
        return itemsInBagWeight
    }
    
    func getItemsInBagVolume () -> Int {
        var itemsInBagVolume = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagVolume += Int(item.volume)
        }
        
        return itemsInBagVolume
    }
    
    func getItemsInBagBatteryConsumption () -> Int {
        var itemsInBatteryConsumption = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBatteryConsumption += Int(item.batteryConsumption)
        }
        
        return itemsInBatteryConsumption
    }

    
    func getItemsInBagCost () -> Int {
        var itemsInBagCost = 0
        for item in self.items.filter({$0.isInBag==true}) {
            itemsInBagCost += Int(item.cost)
        }
        
        return itemsInBagCost
    }
    
    func getSelectedActivitiesDuration() -> Int {
        var selectedActivitiesDuration = 0
        
        for activity in self.activities.filter({$0.isSelected == true}) {
            selectedActivitiesDuration += Int(activity.duration)
        }
        
        return selectedActivitiesDuration
    }

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack(alignment: .center, spacing: CGFloat(5)) {
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.selectedActivitiesPopupVisible = false
                        })
                        {
                            Text("⏳")
                                .grayscale(0.9)
                            Text("\(self.getSelectedActivitiesDuration())")
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                self.hideAllVisiblePopups()
                                self.selectedActivitiesPopupVisible = true
                            }
                        )
                        .simultaneousGesture(
                            DragGesture().onEnded { sth in
                            }
                        )
                    }
                    .frame(width: geometry.size.width / 10, height: self.viewHeight)
                    .popup(
                        isPresented: self.$selectedActivitiesPopupVisible,
                        type: .toast,
                        position: .bottom,
                        closeOnTapOutside: true
                    ) {
                        
                        
                        VStack {
                            
                            Image(systemName: "xmark")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.system(size: 20.0))
                                .padding([.trailing, .bottom], 10)
                                .onTapGesture {
                                    self.selectedActivitiesPopupVisible = false
                                }
                            
                            List(self.activities.filter({$0.isSelected == true}).sorted(by: {$0.duration > $1.duration})) {activity in
                                
                                
                                HStack {
                                    Text(activity.wrappedName)
                                        .frame(width: 125, alignment: .leading)
                                    
                                    Text(activity.durationInHoursAndMinutes)
                                        .frame(width: 80, alignment: .trailing)
                                }
                            }
                            
                        }
                        .padding(.top)
                        .frame(width: self.popupWidth, height: self.popupHeight)
                        .background(Color(red: 0.90, green: 0.9, blue: 0.95))
                        .cornerRadius(10.0)
                        
                    }
                    
                    
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.costPopupVisible = false
                        })
                        {
                            Text("💰")
                                .grayscale(0.9)
                            Text("$\(self.getItemsInBagCost())")
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                self.hideAllVisiblePopups()
                                self.costPopupVisible = true
                            }
                        )
                        .simultaneousGesture(
                            DragGesture().onEnded { sth in
                            }
                        )
                    }
                    .frame(width: geometry.size.width / 10, height: self.viewHeight)
                    .popup(
                        isPresented: self.$costPopupVisible,
                        type: .toast,
                        position: .bottom,
                        closeOnTap: true,
                        closeOnTapOutside: true
                    ) {
                        PopupItemsList(statusName: "cost", popupVisibility: self.$costPopupVisible)
                    }
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.volumePopupVisible = false
                        })
                        {
                            Text("📦")
                                .grayscale(0.9)
                            
                            ProgressBarView(progressBarValue: "volume")
                                .frame(width: 30.0)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                self.hideAllVisiblePopups()
                                self.volumePopupVisible = true
                            }
                        )
                        .simultaneousGesture(
                            DragGesture().onEnded { sth in
                            }
                        )
                        
                        Text("\(self.getItemsInBagVolume()) / \(maxItemsInBagVolume)㎤ (\(maxItemsInBagVolume - self.getItemsInBagVolume()))")
                            .font(.footnote)
                            .foregroundColor(self.volumePopupVisible ? .gray : Color(red: 28/255, green: 29/255, blue: 31/255))
                            .animation(.easeInOut)
                    }
                    .frame(width: geometry.size.width / 5, height: self.viewHeight)
                    .popup(
                        isPresented: self.$volumePopupVisible,
                        type: .toast,
                        position: .bottom
                    ) {
                        VStack {
                            
                            
                            PopupItemsList(statusName: "volume", popupVisibility: self.$volumePopupVisible)
                            
                        }
                        .padding(.top)
                        .frame(width: self.popupWidth, height: self.popupHeight)
                        .background(Color(red: 0.90, green: 0.9, blue: 0.95))
                        .cornerRadius(10.0)
                    }
                    
                    
                    
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.weightPopupVisible = false
                        })
                        {
                            Text("⚖️")
                                .grayscale(0.9)
                            
                            ProgressBarView(progressBarValue: "weight")
                                .frame(width: 30.0)
                            
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                self.hideAllVisiblePopups()
                                self.weightPopupVisible = true
                            }
                        )
                        .simultaneousGesture(
                            DragGesture().onEnded {_ in }
                        )
                        
                        Text("\(self.getItemsInBagWeight()) / \(maxItemsInBagWeight)g (\(maxItemsInBagWeight - self.getItemsInBagWeight()))")
                            .foregroundColor(self.weightPopupVisible ? .gray : Color(red: 28/255, green: 29/255, blue: 31/255))
                            .animation(.easeInOut)
                            .font(.footnote)
                    }
                    .frame(width: geometry.size.width / 5, height: self.viewHeight)
                    .popup(
                        isPresented: self.$weightPopupVisible,
                        type: .toast,
                        position: .bottom
                    ) {
                        PopupItemsList(statusName: "weight", popupVisibility: self.$weightPopupVisible)
                    }
                    
                    
                    HStack(alignment: .center){
                        Button(action:{
                            self.batteryConsumptionPopupVisible = false
                        })
                        {
                            Text("🔋")
                                .grayscale(0.9)
                            
                            ProgressBarView(progressBarValue: "batteryConsumption")
                                .frame(width: 30.0)
                        }
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: 0.1).onEnded { _ in
                                self.hideAllVisiblePopups()
                                self.batteryConsumptionPopupVisible = true
                            }
                        )
                        .simultaneousGesture(
                            DragGesture().onEnded { sth in
                            }
                        )
                        
                        Text("\(self.getItemsInBagBatteryConsumption())%")
                            .foregroundColor(self.batteryConsumptionPopupVisible ? .gray : Color(red: 208/255, green: 207/255, blue: 207/255))
                            .animation(.easeInOut)
                    }
                    .frame(width: geometry.size.width / 5, height: self.viewHeight)
                    .popup(
                        isPresented: self.$batteryConsumptionPopupVisible,
                        type: .toast,
                        position: .bottom
                    ) {
                        PopupItemsList(statusName: "battery", popupVisibility: self.$batteryConsumptionPopupVisible)
                    }
                }
                .background(Color(red: 28/255, green: 29/255, blue: 31/255))
                .foregroundColor(.gray)
                .font(.footnote)
                
                .frame(width: geometry.size.width)
                .padding()
                
            }
            .background(Color(red: 28/255, green: 29/255, blue: 31/255))
            .frame(width: geometry.size.width, height: 50)
            //        .opacity(0.8)
            
            
            
        }
        .frame(height: 55)
        
        
        
    }
}

struct VolumeWeightDurationIndicatorsView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeWeightDurationIndicatorsView()
    }
}
