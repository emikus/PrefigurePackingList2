//
//  PanelsView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct PanelHandleView: View {
    @Binding var panelHeight:CGFloat
    
    var body: some View {
        ZStack {
        Image(systemName: "minus")
            .font(.system(size: 40, weight: .semibold))
            .foregroundColor(fontSecondaryColour)
            .offset(y: self.panelHeight > 15 ? -5 : 0)
        }
    }
}

struct PanelsView: View {
    @AppStorage("panelOneHeight") var panelOneHeight: Int = 100
    @AppStorage("panelTwoHeight") var panelTwoHeight: Int = 100
    @AppStorage("panelThreeHeight") var panelThreeHeight: Int = 100
    @State var isDragging = false
//    @State var panelOneHeight = 100.0
//    @State var panelTwoHeight = 100.0
//    @State var panelThreeHeight = 100.0
    
    @State var panelsHeight = [
        CGFloat(100),
        CGFloat(100),
        CGFloat(100)
    ]
    
    let minimalPanelHeight = CGFloat(15)
    let panelContentVisibilityMinHeight = 40
    
    
    
    func calculatePanelsHeightForFirstPanel(translationHeight: CGFloat) {
        
        let firstPanelHeightIsBetweenLimits = self.panelsHeight[0] + translationHeight < 301 && self.panelsHeight[0] + translationHeight > 0
        
        if firstPanelHeightIsBetweenLimits && self.panelsHeight.reduce(0, +) < 301 {
            self.panelsHeight[0] += translationHeight
            
            if self.panelsHeight[1] - translationHeight > CGFloat(self.minimalPanelHeight) && (self.panelsHeight[2] > 99 || self.panelsHeight[2] == 0)  {
                self.panelsHeight[1] -= translationHeight
            } else {
                self.panelsHeight[2] -= translationHeight
            }
        }
    }
    
    
    func calculatePanelsHeightForSecondPanel(translationHeight: CGFloat) {
        var secondPanelHeightIsBetweenLimits: Bool = false
        
        switch self.panelsHeight[0] {
        case CGFloat(self.minimalPanelHeight):
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 301 && self.panelsHeight[1] + translationHeight > 0
        case 100:
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 201 && self.panelsHeight[1] + translationHeight > 0
        case 200:
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 201 && self.panelsHeight[1] + translationHeight > 0
        default:
            secondPanelHeightIsBetweenLimits = false
        }
        if secondPanelHeightIsBetweenLimits && self.panelsHeight.reduce(0, +) < 301 {
            self.panelsHeight[1] += translationHeight
            self.panelsHeight[2] = self.panelsHeight[2] >= 0 ? self.panelsHeight[2] - translationHeight : 0
            print(self.panelsHeight[0])
            print(self.panelsHeight[1])
            print(self.panelsHeight[2])
            print(self.panelsHeight.reduce(0, +))
        }
    }
    
    
    
    var dragForPanelOne: some Gesture {
        DragGesture()
            .onChanged { value in
                
                self.calculatePanelsHeightForFirstPanel(translationHeight: value.translation.height)
                
                self.isDragging = true
                
            }
            .onEnded { value in
                self.isDragging = false
                
                if self.panelsHeight[0] <= 50 {
                    var secondPanelHeight:Int
                    
                    switch self.panelsHeight[2] {
                    case 0:
                        secondPanelHeight = 285
                    case 100:
                        secondPanelHeight = 185
                    case 185:
                        secondPanelHeight = 100
                    default:
                        secondPanelHeight = Int(self.minimalPanelHeight)
                    }
                    
                    
                    
                    self.panelsHeight = [
                        self.minimalPanelHeight,
                        CGFloat(secondPanelHeight),
                        self.panelsHeight[2] > 200 ? 270 : self.panelsHeight[2]
                    ]
                    
                } else if self.panelsHeight[0] > 50 && self.panelsHeight[0] <= 150 {
                    self.panelsHeight = [
                        100,
                        self.panelsHeight[2] > 100 ? self.minimalPanelHeight : 200 - self.panelsHeight[2],
                        self.panelsHeight[2] > 101 ? 185 : self.panelsHeight[2]
                    ]
                }  else if self.panelsHeight[0] > 150 && self.panelsHeight[0] <= 185 {
                    self.panelsHeight = [
                        self.panelsHeight[2] == 0 ? 200 : 185,
                        self.panelsHeight[2] == 0 ? 100 : self.minimalPanelHeight,
                        self.panelsHeight[2]
                    ]
                } else if self.panelsHeight[0] >= 185 && self.panelsHeight[0] <= 250 {
                    self.panelsHeight = [
                        self.panelsHeight[2] == 0 ? 200 : 185,
                        self.panelsHeight[2] == 0 ? 100 : self.minimalPanelHeight,
                        self.panelsHeight[2] == 0 ? 0 : 100
                    ]
                } else if self.panelsHeight[0] > 250 && self.panelsHeight[0] <= 400 {
                    self.panelsHeight = [
                        285,
                        self.minimalPanelHeight,
                        0
                    ]
                }
            }
    }
    
    
    
    
    
    var dragForPanelTwo: some Gesture {
        DragGesture()
            .onChanged { value in
                
                self.calculatePanelsHeightForSecondPanel(translationHeight: value.translation.height)
                
                self.isDragging = true
                
            }
            .onEnded { value in
                self.isDragging = false
                
                let firstPanelHeight = self.panelsHeight[0]
                
                
                if self.panelsHeight[1] <= 50 {
                    
                    
                    
                    self.panelsHeight = [
                        firstPanelHeight == 200 ? 185 : firstPanelHeight,
                        self.minimalPanelHeight,
                        firstPanelHeight == 200 ? 100 : 300 - firstPanelHeight - self.minimalPanelHeight
                    ]
                } else if self.panelsHeight[1] > 50 && self.panelsHeight[1] <= 150 {
                    
                    
                    
                    self.panelsHeight = [
                        firstPanelHeight,
                        100,
                        200 - firstPanelHeight
                    ]
                    
                } else if self.panelsHeight[1] > 150 && self.panelsHeight[1] <= 250 {
                    var secondPanelHeight:Int
                    
                    if firstPanelHeight == 15 && self.panelsHeight[2] == 0 {
                        secondPanelHeight = 285
                    } else if firstPanelHeight == 100 && self.panelsHeight[2] < 50 {
                        secondPanelHeight = 200

                    } else {
                        secondPanelHeight = 185
                    }
                    
                    
                    
                    
                    
                    self.panelsHeight = [
                        firstPanelHeight,
                        CGFloat(secondPanelHeight),
                        firstPanelHeight == 15 ? 100 : 0
                    ]
                    
                } else if self.panelsHeight[1] > 250 && self.panelsHeight[1] <= 300 {
                    self.panelsHeight = [
                        firstPanelHeight,
                        285,
                        0
                    ]
                }
                
                
            }
    }
    
    
    var body: some View {
        
        VStack {
            
            VStack {
                HStack {
                    VStack {
                        if Int(self.panelsHeight[0]) > 15 {
                            
                        Text(String(Int(self.panelsHeight[0])))
                            .foregroundColor(.red)
                            .font(panelsHeight[0] == 10 ? .system(size: 1) : .body)
                            .opacity(Int(self.panelsHeight[0]) > self.panelContentVisibilityMinHeight ? 1.0 : 0.0 + Double(self.panelsHeight[0]) / 40)
                            Spacer()

                        }
                        PanelHandleView(panelHeight: $panelsHeight[0])
                        .gesture(self.dragForPanelOne)
                    }
                    
                }
//                .padding(.bottom, 5)
                .frame(width: CGFloat(1100), height: CGFloat(self.panelsHeight[0]))
                .border(fontMainColour, width: 1)
                .background(fontMainColour.opacity(0.5))
                
                HStack {
                    VStack {
                        if Int(self.panelsHeight[1]) > 15 {
                                Text(String(Int(self.panelsHeight[1])))
                                Text(String(Int(self.panelsHeight[1])))
                                Text(String(Int(self.panelsHeight[1])))
                            Text(String(Int(self.panelsHeight[1])))
                            .foregroundColor(.yellow)
                            .font(panelsHeight[1] == 10 ? .system(size: 1) : .body)
                            .opacity(Int(self.panelsHeight[1]) > self.panelContentVisibilityMinHeight ? 1.0 : 0.0 + Double(self.panelsHeight[1]) / 40)
                            
                        Spacer()
                            
                        }
                        PanelHandleView(panelHeight: $panelsHeight[1])
                        .gesture(self.dragForPanelTwo)
                    }
                    .opacity(Int(self.panelsHeight[1]) > self.panelContentVisibilityMinHeight ? 1.0 : 0.0 + Double(self.panelsHeight[0]) / 20)
                }
                .frame(width: CGFloat(1100), height: CGFloat( self.panelsHeight[1]))
                .border(fontSecondaryColour, width: 1)
                .background(fontMainColour.opacity(0.3))
                
                HStack {
                    VStack {
                        if Int(self.panelsHeight[2]) > 15 {
                            Text(String(Int(self.panelsHeight[2])))
                                .foregroundColor(listHeaderColour)
                                .opacity(Int(self.panelsHeight[2]) > self.panelContentVisibilityMinHeight ? 1.0 : 0.0 + Double(self.panelsHeight[2]) / 40)
                            Spacer()
//
                        }
                    }
                }
                .frame(width: CGFloat(1100), height: CGFloat(self.panelsHeight[2]))
                .border(fontSecondaryColour, width: 1)
                .background(fontMainColour.opacity(0.1))
                
                
            }
            .frame(width: 1100, height: 300, alignment: .center)
            .border(fontMainColour)
        }
        .animation(self.isDragging ? .none : .easeInOut)
        .onAppear(perform: {
            
            self.panelsHeight[0] = CGFloat(self.panelOneHeight)
            self.panelsHeight[1] = CGFloat(self.panelTwoHeight)
            self.panelsHeight[2] = CGFloat(self.panelThreeHeight)
        })
        .onDisappear(perform: {
            self.panelOneHeight = Int(self.panelsHeight[0])
            self.panelTwoHeight = Int(self.panelsHeight[1])
            self.panelThreeHeight = Int(self.panelsHeight[2])
        })
        
    }
}



struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelsView()
    }
}
