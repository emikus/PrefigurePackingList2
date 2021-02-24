//
//  Icon.swift
//
//  Created by Zac White.
//  Copyright © 2020 Velos Mobile LLC / https://velosmobile.com / All rights reserved.
//

import SwiftUI

struct Icon : View {
    
    var themeColours:ThemeColours

    var body: some View {
        /// Note: All of these assume a canvas size of 1024.
        let spacing: CGFloat = 80
        let radius: CGFloat = 32
        let pillLength: CGFloat = 250
        let pillRotation: Angle = .degrees(30)
        let circleOffsetX: CGFloat = 50
        let circleOffsetY: CGFloat = 20

        let velosBackground = themeColours.bgMainColour //Color(red: 90/256, green: 80/256, blue: 5/256)
        let velosPrimary = themeColours.fontMainColour
        let velosSecondary = themeColours.fontSecondaryColour //Color(red: 0/256, green: 208/256, blue: 55/256)

        return IconStack { canvas in
            velosBackground
                .edgesIgnoringSafeArea(.all)

            HStack(alignment: .center, spacing: canvas[spacing]) {
                HStack(alignment: .top, spacing: canvas[spacing]) {
                    Circle()
                        .fill(velosPrimary)
                        .frame(width: canvas[radius], height: canvas[radius])
                        .offset(x: canvas[circleOffsetX], y: canvas[circleOffsetY])
                    RoundedRectangle(cornerRadius: canvas[radius])
                        .fill(velosPrimary)
                        .frame(width: canvas[radius], height: canvas[pillLength])
                        .rotationEffect(pillRotation)
                }
                HStack(alignment: .bottom, spacing: canvas[spacing]) {
                    RoundedRectangle(cornerRadius: canvas[radius])
                        .fill(velosSecondary)
                        .frame(width: canvas[radius], height: canvas[pillLength])
                        .rotationEffect(pillRotation)
                    RoundedRectangle(cornerRadius: canvas[radius])
                        .fill(velosSecondary)
                        .frame(width: canvas[radius], height: canvas[pillLength])
                        .rotationEffect(pillRotation)
                    Circle()
                        .fill(velosSecondary)
                        .frame(width: canvas[radius], height: canvas[radius])
                        .offset(x: -canvas[circleOffsetX], y: -canvas[circleOffsetY])
                }
            }
        }
    }
}

#if DEBUG
struct Icon_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            Icon(themeColours: themes[0].themeColours)
                .previewIcon()
                .previewLayout(.sizeThatFits)

            Icon(themeColours: themes[0].themeColours)
                .previewHomescreen()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .orange]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .previewLayout(.fixed(width: 500, height: 500))
        }
    }
}
#endif
