//
//  GridItemWrapper.swift
//  PPL
//
//  Created by Macbook Pro on 16/10/2020.
//

import Foundation


class  GridItemWrapper: Identifiable, Equatable {
    static func == (lhs: GridItemWrapper, rhs: GridItemWrapper) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var item: Item
    
    init(id: Int, item: Item) {
        self.id = id
        self.item = item
    }
    
}
