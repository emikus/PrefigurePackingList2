//
//  ModelHardCoded.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import Foundation

var tagIconSuggestions: [String: String] = [
    "football": "sportscourt",
    "volleyball": "sportscourt",
    "swimming": "sportscourt",
    "skating": "sportscourt",
    "tennis": "sportscourt",
    "snowboarding": "sportscourt",
    "windsurfing": "sportscourt",
    "kitesurfing": "sportscourt",
    "sailing": "sportscourt",
    "bike": "sportscourt",
    "jogging": "sportscourt",
    "running": "sportscourt",
    "climbing": "sportscourt",
    "work": "dollarsign.circle",
    "money": "dollarsign.circle",
    "office": "dollarsign.circle",
    "clientmeeting": "dollarsign.circle",
    "travel": "airplane",
    "flight": "airplane"
]

var sampleModules: [String:String] = [
    "🟦": "First Item",
    "🟠": "Second Item",
    "⭕️": "",
    "🧤": "",
    "🚀": "",
    "🌞": "",
    "🛄": "",
    "🔊": "",
    "🀄️": "",
    "🎹": "",
    "🤿": "",
    "🍾": ""
]


var activitiesCategories = ["general", "specific", "other"]
var maxItemsInBagWeight = 5000
var maxItemsInBagVolume = 6000
var maxItemsInBagBatteryConsumption = 100


enum DnDSourceView {
    case itemsList
    case modules
    case smartShelf
}

var dNdSourceView: DnDSourceView = .itemsList



class Modules: ObservableObject, Identifiable {
    
    @Published var standBookModeModulesFrontOccupation = [
        "🛀": "",
        "🔱": "",
        "🚦": "",
        "🗿": "",
        "🚢": "",
        "🎯": "",
        "🧉": "",
        "🥑": "",
        "🌈": "",
        "🍄": "",
        "🦥": "",
        "🐠": ""
    ]
    
    @Published var standBookModeModulesBackOccupation = [
        "🍴": "",
        "🥎":"",
        "🎖":"",
        "🚀":"",
        "🎚":"",
        "🎛":"",
        "💉":"",
        "🧤":"",
        "🚔":"",
        "💻":"",
        "🏖":"",
        "🤿":""
    ]
    
    @Published var standMessengerModeModulesFrontOccupation = [
        "🟦": "",
        "🟠": "",
        "⭕️": "",
        "🧤": "",
        "🚀": "",
        "🌞": ""
    ]
    
    
    
    @Published var standMessengerModeModulesBackOccupation = [
        "🛄": "",
        "🔊": "",
        "🀄️": "",
        "🎹": "",
        "🤿": "",
        "🍾": ""
    ]
    
    @Published var strapOneFrontModulesOccupation = [
        "🕸": "",
        "🥎":"",
        "🎖":"",
        "🚀":"",
        "🏵":"",
        "🧩":"",
        "🚜":"",
        "🎹":""
    ]
    
    @Published var strapOneBackModulesOccupation = [
        "🕸": "",
        "🥎":"",
        "🎖":"",
        "🚀":"",
        "🏵":"",
        "🧩":"",
        "🚜":"",
        "🎹":""
        ]
    
    @Published var strapTwoFrontModulesOccupation = [
        "🎚":"",
        "🎛":"",
        "💉":"",
        "🧤":"",
        "🚔":"",
        "💻":"",
        "🏖":"",
        "🕸":""
        ]
    
    @Published var strapTwoBackModulesOccupation = [
        "🎚":"",
        "🎛":"",
        "💉":"",
        "🧤":"",
        "🚔":"",
        "💻":"",
        "🏖":"",
        "🕸":""
        ]
    
    @Published var highlightedModule = ""
    private var allModulesOccupation: [[String:String]] = []
        
    init() {
        self.allModulesOccupation.append(self.standBookModeModulesFrontOccupation)
        self.allModulesOccupation.append(self.standBookModeModulesBackOccupation)
        self.allModulesOccupation.append(self.standMessengerModeModulesFrontOccupation)
        self.allModulesOccupation.append(self.standMessengerModeModulesBackOccupation)
        self.allModulesOccupation.append(self.strapOneFrontModulesOccupation)
        self.allModulesOccupation.append(self.strapOneBackModulesOccupation)
        self.allModulesOccupation.append(self.strapTwoFrontModulesOccupation)
        self.allModulesOccupation.append(self.strapTwoBackModulesOccupation)
    }
    
    var freeModulesSlots: [String: String] {
        var freeModulesSlots: [String: String] = [:]
        
        let standModulesFrontOccupationFreeModulesSlots = self.standMessengerModeModulesFrontOccupation.filter { key, value in
            return value == ""
        }
        
        let standModulesBackOccupationFreeModulesSlots = self.standMessengerModeModulesBackOccupation.filter { key, value in
            return value == ""
        }
        
        let strapOneFrontModulesOccupationFreeModulesSlots = self.strapOneFrontModulesOccupation.filter { key, value in
            return value == ""
        }
        
        let strapOneBackModulesOccupationFreeModulesSlots = self.strapOneBackModulesOccupation.filter { key, value in
            return value == ""
        }
        
        let strapTwoFrontModulesOccupationFreeModulesSlots = self.strapTwoFrontModulesOccupation.filter { key, value in
            return value == ""
        }
        
        let strapTwoBackModulesOccupationFreeModulesSlots = self.strapTwoBackModulesOccupation.filter { key, value in
            return value == ""
        }
        
        freeModulesSlots.merge(standModulesFrontOccupationFreeModulesSlots) { (_, second) in second }
        freeModulesSlots.merge(standModulesBackOccupationFreeModulesSlots) { (_, second) in second }
        freeModulesSlots.merge(strapOneFrontModulesOccupationFreeModulesSlots) { (_, second) in second }
        freeModulesSlots.merge(strapOneBackModulesOccupationFreeModulesSlots) { (_, second) in second }
        freeModulesSlots.merge(strapTwoFrontModulesOccupationFreeModulesSlots) { (_, second) in second }
        freeModulesSlots.merge(strapTwoBackModulesOccupationFreeModulesSlots) { (_, second) in second }
        
        return freeModulesSlots
    }
    
    func recreateBagContentSet(modulesAndTheirItems: [String:[String:Item]]) {
        if (modulesAndTheirItems["standMessengerModeModulesFrontOccupation"]!.count > 0) {
            modulesAndTheirItems["standMessengerModeModulesFrontOccupation"]!.forEach{ (key, value) in self.standMessengerModeModulesFrontOccupation[key] = value.name }
        }
        
        if (modulesAndTheirItems["standMessengerModeModulesBackOccupation"]!.count > 0) {
            modulesAndTheirItems["standMessengerModeModulesBackOccupation"]!.forEach{ (key, value) in self.standMessengerModeModulesBackOccupation[key] = value.name }
        }
        
        if (modulesAndTheirItems["standBookModeModulesFrontOccupation"]!.count > 0) {
            modulesAndTheirItems["standBookModeModulesFrontOccupation"]!.forEach{ (key, value) in self.standBookModeModulesFrontOccupation[key] = value.name }
        }
        
        if (modulesAndTheirItems["standBookModeModulesBackOccupation"]!.count > 0) {
            modulesAndTheirItems["standBookModeModulesBackOccupation"]!.forEach{ (key, value) in self.standBookModeModulesBackOccupation[key] = value.name }
        }
        
        if (modulesAndTheirItems["strapOneFrontModulesOccupation"]!.count > 0) {
            modulesAndTheirItems["strapOneFrontModulesOccupation"]!.forEach{ (key, value) in self.strapOneFrontModulesOccupation[key] = value.name }
        }
        
        
        
        if (modulesAndTheirItems["strapOneBackModulesOccupation"]!.count > 0) {
            modulesAndTheirItems["strapOneBackModulesOccupation"]!.forEach{ (key, value) in self.strapOneBackModulesOccupation[key] = value.name }
        }
        
        
        
        if (modulesAndTheirItems["strapTwoFrontModulesOccupation"]!.count > 0) {
            modulesAndTheirItems["strapTwoFrontModulesOccupation"]!.forEach{ (key, value) in self.strapTwoFrontModulesOccupation[key] = value.name }
        }
        
        if (modulesAndTheirItems["strapTwoBackModulesOccupation"]!.count > 0) {
            modulesAndTheirItems["strapTwoBackModulesOccupation"]!.forEach{ (key, value) in self.strapTwoBackModulesOccupation[key] = value.name }
        }
    }
    
    
    func addRemoveItemToModule(item: Item) {
        let itemName = item.name
        
        if item.isInModuleSlot == true {
            if self.standMessengerModeModulesFrontOccupation[item.wrappedModuleSymbol] == itemName {
                self.standMessengerModeModulesFrontOccupation[item.wrappedModuleSymbol] = ""
            } else if self.standMessengerModeModulesBackOccupation[item.wrappedModuleSymbol] == itemName {
                self.standMessengerModeModulesBackOccupation[item.wrappedModuleSymbol] = ""
            } else if self.standBookModeModulesFrontOccupation[item.wrappedModuleSymbol] == itemName {
                self.standBookModeModulesFrontOccupation[item.wrappedModuleSymbol] = ""
            } else if self.standBookModeModulesBackOccupation[item.wrappedModuleSymbol] == itemName {
                self.standBookModeModulesBackOccupation[item.wrappedModuleSymbol] = ""
            } else if self.strapOneFrontModulesOccupation[item.wrappedModuleSymbol] == itemName {
                self.strapOneFrontModulesOccupation[item.wrappedModuleSymbol] = ""
            } else if self.strapOneBackModulesOccupation[item.wrappedModuleSymbol] == itemName {
                self.strapOneBackModulesOccupation[item.wrappedModuleSymbol] = ""
            } else if self.strapTwoFrontModulesOccupation[item.wrappedModuleSymbol] == itemName {
                self.strapTwoFrontModulesOccupation[item.wrappedModuleSymbol] = ""
            } else if self.strapTwoBackModulesOccupation[item.wrappedModuleSymbol] == itemName {
                self.strapTwoBackModulesOccupation[item.wrappedModuleSymbol] = ""
            }
            
        } else {
            
            if self.standMessengerModeModulesFrontOccupation[item.wrappedModuleSymbol] == "" {
                self.standMessengerModeModulesFrontOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.standMessengerModeModulesBackOccupation[item.wrappedModuleSymbol] == "" {
                self.standMessengerModeModulesBackOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.standBookModeModulesFrontOccupation[item.wrappedModuleSymbol] == "" {
                self.standBookModeModulesFrontOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.standBookModeModulesBackOccupation[item.wrappedModuleSymbol] == "" {
                self.standBookModeModulesBackOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.strapOneFrontModulesOccupation[item.wrappedModuleSymbol] == "" {
                self.strapOneFrontModulesOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.strapOneBackModulesOccupation[item.wrappedModuleSymbol] == "" {
                self.strapOneBackModulesOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.strapTwoFrontModulesOccupation[item.wrappedModuleSymbol] == "" {
                self.strapTwoFrontModulesOccupation[item.wrappedModuleSymbol] = itemName
            } else if self.strapTwoBackModulesOccupation[item.wrappedModuleSymbol] == "" {
                self.strapTwoBackModulesOccupation[item.wrappedModuleSymbol] = itemName
            }
            
        }
       
        item.isInModuleSlot.toggle()
    }
}

var itemCategories = ["electrical", "clothes", "food"]
var modules = Modules()
