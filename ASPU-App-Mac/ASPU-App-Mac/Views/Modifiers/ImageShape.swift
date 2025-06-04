//
//  ImageShape.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import SwiftUI

struct ImageShape: ViewModifier {
    
    @AppStorage("image shape") var shape = ImageShapes.square
    @AppStorage("image line width") var width = 0.0
    @AppStorage("image shadow radius") var shadowRadius = 0.0
    @AppStorage("image width") var imageWidth = 100.0
    @AppStorage("image height") var imageHeight = 100.0
    @AppStorage("image rotatition angle") var rotatingAngle = 0.0
    
    func body(content: Content) -> some View {
        switch shape {
        case .square:
            content
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: width)
                )
                .shadow(color: .primary, radius: shadowRadius)
                .rotationEffect(.degrees(rotatingAngle))
        case .circle:
            content
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.primary, lineWidth: width)
                )
                .shadow(color: .primary, radius: shadowRadius)
                .rotationEffect(.degrees(rotatingAngle))
        }
    }
}
