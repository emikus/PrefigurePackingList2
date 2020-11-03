//
//  PanelsView.swift
//  PPL
//
//  Created by Macbook Pro on 09/10/2020.
//

import SwiftUI

struct PanelsView: View {
    @State var isDragging = false
    @State var panelOneHeight = 100.0
    @State var panelTwoHeight = 100.0
    @State var panelThreeHeight = 100.0
    
    @State var panelsHeight = [
        CGFloat(100),
        CGFloat(100),
        CGFloat(100)
    ]
    
    
    func calculatePanelsHeightForFirstPanel(translationHeight: CGFloat) {
        
        let firstPanelHeightIsBetweenLimits = self.panelsHeight[0] + translationHeight < 301 && self.panelsHeight[0] + translationHeight > 0
        
        if firstPanelHeightIsBetweenLimits {
            self.panelsHeight[0] += translationHeight
            
            if self.panelsHeight[1] - translationHeight > 10 && self.panelsHeight[2] > 99 {
                self.panelsHeight[1] -= translationHeight
            } else {
                self.panelsHeight[2] -= translationHeight
            }
        }
    }
    
    
    func calculatePanelsHeightForSecondPanel(translationHeight: CGFloat) {
        var secondPanelHeightIsBetweenLimits: Bool = false
        
        switch self.panelsHeight[0] {
        case 10:
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 301 && self.panelsHeight[1] + translationHeight > 0
        case 100:
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 201 && self.panelsHeight[1] + translationHeight > 0
        case 200:
            secondPanelHeightIsBetweenLimits = self.panelsHeight[1] + translationHeight < 201 && self.panelsHeight[1] + translationHeight > 0
        default:
            secondPanelHeightIsBetweenLimits = false
        }
        
        
        //        let draggedPanelHeightIsBetweenLimits = self.panelsHeight[0] + translationHeight < 301 && self.panelsHeight[0] + translationHeight > 0
        
        if secondPanelHeightIsBetweenLimits {
            self.panelsHeight[1] += translationHeight
            self.panelsHeight[2] -= translationHeight
        }
    }
    
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                
                self.calculatePanelsHeightForFirstPanel(translationHeight: value.translation.height)
                
                self.isDragging = true
                
            }
            .onEnded { value in
                self.isDragging = false
                
                if self.panelsHeight[0] <= 50 {
                    self.panelsHeight = [10, 200, 100]
                    
                } else if self.panelsHeight[0] > 50 && self.panelsHeight[0] <= 100 {
                    self.panelsHeight = [100, 100, 100]
                } else if self.panelsHeight[0] > 100 && self.panelsHeight[0] <= 150 {
                    self.panelsHeight = [100, 100, 100]
                } else if self.panelsHeight[0] > 150 && self.panelsHeight[0] <= 200 {
                    self.panelsHeight = [200, 10, 100]
                } else if self.panelsHeight[0] > 200 && self.panelsHeight[0] <= 250 {
                    self.panelsHeight = [200, 10, 100]
                } else if self.panelsHeight[0] > 250 && self.panelsHeight[0] <= 300 {
                    self.panelsHeight = [300, 10, 10]
                }
            }
    }
    
    
    
    
    
    var drag2: some Gesture {
        DragGesture()
            .onChanged { value in
                
                self.calculatePanelsHeightForSecondPanel(translationHeight: value.translation.height)
                
                self.isDragging = true
                
            }
            .onEnded { value in
                self.isDragging = false
                
                let firstPanelHeight = self.panelsHeight[0]
                
                
                if self.panelsHeight[1] <= 50 {
                    self.panelsHeight = [firstPanelHeight, 10, 300 - firstPanelHeight - 10]
                } else if self.panelsHeight[1] > 50 && self.panelsHeight[1] <= 150 {
                    self.panelsHeight = [firstPanelHeight, 100, 200 - firstPanelHeight]
                    
                } else if self.panelsHeight[1] > 150 && self.panelsHeight[1] <= 250 {
                    self.panelsHeight = [firstPanelHeight, 200, 100 - firstPanelHeight]
                    
                } else if self.panelsHeight[1] > 250 && self.panelsHeight[1] <= 300 {
                    self.panelsHeight = [firstPanelHeight, 300, 10]
                }
            }
    }
    
    
    var body: some View {
        
        VStack {
            
            VStack {
                HStack {
                    VStack {
                        Text("I'm panel ONE")
                            .foregroundColor(.red)
                            .font(panelsHeight[0] == 10 ? .system(size: 1) : .body)
                        
                        Spacer()
                        Image(systemName: "minus")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(.gray)
                            .gesture(self.drag)
                    }
                }
                .frame(width: CGFloat(1100), height: CGFloat(self.panelsHeight[0]))
                .border(Color.gray, width: 1)
                .background(Color(red: 28/255, green: 29/255, blue: 31/255))
                
                HStack {
                    VStack {
                        Text("And I'm panel TWO")
                            .foregroundColor(.yellow)
                            .font(panelsHeight[1] == 10 ? .system(size: 1) : .body)
                        Spacer()
                        Image(systemName: "minus")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(.gray)
                            .gesture(self.drag2)
                    }
                }
                .frame(width: CGFloat(1100), height: CGFloat( self.panelsHeight[1]))
                .border(Color.gray, width: 1)
                .background(Color(red: 48/255, green: 49/255, blue: 51/255))
                
                HStack {
                    VStack {
                        Text("Here we are - panel THREE")
                            .foregroundColor(.yellow)
                        Spacer()
                        
                    }
                }
                .frame(width: CGFloat(1100), height: CGFloat(self.panelsHeight[2]))
                .border(Color.gray, width: 1)
                .background(Color(red: 68/255, green: 69/255, blue: 71/255))
                
                
            }
        }
        .animation(self.isDragging ? .none : .easeInOut)
    }
}



struct PanelsView_Previews: PreviewProvider {
    static var previews: some View {
        PanelsView()
    }
}
