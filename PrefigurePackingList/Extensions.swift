//
//  Extensions.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 13/08/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
