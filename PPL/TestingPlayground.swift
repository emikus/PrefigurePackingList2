//
//  TestingPlayground.swift
//  PPL
//
//  Created by Michal Jendrzejewski on 07/03/2021.
//

import SwiftUI

struct TestingPlayground: View {
    var body: some View {
        NavigationView {
            Text("12345")
            Text("987654")
            Text("asdfasdf")
        }
    }
}

struct TestingPlayground_Previews: PreviewProvider {
    static var previews: some View {
        TestingPlayground()
            .previewLayout(
                PreviewLayout.fixed(
                    width: 2732.0,
                    height: 2048.0
                )
            )
    }
}
