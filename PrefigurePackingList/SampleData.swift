//
//  SampleData.swift
//  PrefigurePackingList
//
//  Created by Macbook Pro on 02/08/2020.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

import Foundation


let sampleActivites = [
    Activity(
        name: "Sport",
        symbol: "sportscourt",
        duration: Int.random(in: 10...100),
        items: [sampleItems[0],
                sampleItems[1],
                sampleItems[2]],
        category: .general),
    Activity(
        name: "Leisure",
        symbol: "tv.music.note",
        duration: Int.random(in: 10...100),
        items: [sampleItems[4],
                sampleItems[5],
                sampleItems[6]],
        category: .other),
    Activity(
        name: "Self development",
        symbol: "book",
        duration: Int.random(in: 10...100),
        items: [sampleItems[7],
                sampleItems[8],
                sampleItems[9]],
        category: .specific),
    Activity(
        name: "Work",
        symbol: "dollarsign.circle",
        duration: Int.random(in: 10...100),
        items: [sampleItems[3],
                sampleItems[4],
                sampleItems[11],
                sampleItems[6]],
        category: .general),
    Activity(
        name: "Music",
        symbol: "guitars",
        duration: Int.random(in: 10...100),
        items: [sampleItems[0],
                sampleItems[9],
                sampleItems[10],
                sampleItems[3]],
        category: .other),
    Activity(
        name: "Hobby",
        symbol: "hammer",
        duration: Int.random(in: 10...100),
        items: [sampleItems[8],
                sampleItems[6],
                sampleItems[9]],
        category: .specific)
]

let sampleItems:[Item] = [
    Item(name: "First Item", weight: 20, volume: 34, activities: [1,2]),
    Item(name: "Second Item", weight: 47, volume: 66, activities: [1,2]),
    Item(name: "Third Item", weight: 32, volume: 18, activities: [1,2]),
    Item(name: "Fourth Item", weight: 89, volume: 51, activities: [1,2]),
    Item(name: "Fifth Item", weight: 12, volume: 75, activities: [1,2]),
    Item(name: "Sixth Item", weight: 99, volume: 93, activities: [1,2]),
    Item(name: "Seventh Item", weight: 59, volume: 19, activities: [1,2]),
    Item(name: "Eigth Item", weight: 98, volume: 87, activities: [1,2]),
    Item(name: "Ninth Item", weight: 77, volume: 55, activities: [1,2]),
    Item(name: "Tenth Item", weight: 17, volume: 29, activities: [1,2]),
    Item(name: "Eleventh Item", weight: 49, volume: 14, activities: [1,2]),
    Item(name: "Tvelvth Item", weight: 63, volume: 8, activities: [1,2])
]
