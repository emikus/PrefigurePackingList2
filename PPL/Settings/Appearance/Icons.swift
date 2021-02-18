//
//  Icons.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 10/02/2021.
//

import Foundation
import SwiftUI



class IconNames: ObservableObject {
    var iconNames: [String?] = [nil]
    @Published var currentIndex = 0
    
    init() {
        getAlternateIconNames()
        
        if let currentIcon = UIApplication.shared.alternateIconName{
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getAlternateIconNames(){
        
        print(Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any])
//        print(Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons"))
            if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
                let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any]
            {
                     
                 for (_, value) in alternateIcons{

                    guard let iconList = value as? Dictionary<String, Any> else{return}
                     guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                         else{return}
                         
                     guard let icon = iconFiles.first else{return}
                     iconNames.append(icon)
        
                 }
            }
    }
}
