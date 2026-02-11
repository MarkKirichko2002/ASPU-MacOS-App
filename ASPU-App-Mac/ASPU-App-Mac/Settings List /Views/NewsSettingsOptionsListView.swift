//
//  NewsSettingsOptionsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import SwiftUI

enum ImageShapes: String, Codable, CaseIterable, Hashable {
    case square
    case circle
    
    var title: String {
        switch self {
        case .square:
            return "Квадрат"
        case .circle:
            return "Круг"
        }
    }
}

struct NewsSettingsOptionsListView: View {
    
    @AppStorage("image shape") var shape = ImageShapes.square
    @AppStorage("image line width") var width = 0.0
    @AppStorage("image shadow radius") var shadowRadius = 0.0
    @AppStorage("image width") var imageWidth = 100.0
    @AppStorage("image height") var imageHeight = 100.0
    @AppStorage("image rotatition angle") var rotatingAngle = 0.0
    
    var body: some View {
        HStack(spacing: 20) {
            Image("главный корпус")
                .resizable()
                .modifier(ImageShape())
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .center, spacing: 30) {
                    Text("Фигура для изображения")
                        .fontWeight(.black)
                    Picker("", selection: $shape) {
                        ForEach(ImageShapes.allCases, id: \.self) { shape in
                            Text(shape.title)
                        }
                    }.fontWeight(.black)
                    .onChange(of: shape) { oldValue, newValue in
                        shape = newValue
                    }
                }
                VStack(alignment: .center, spacing: 30) {
                    Text("Ширина обводки изображения (\(Int(width)))")
                        .fontWeight(.black)
                    Slider(value: $width, in: 0...10)
                }
                
                VStack(alignment: .center, spacing: 30) {
                    Text("Радиус тени изображения (\(Int(shadowRadius)))")
                        .fontWeight(.black)
                    Slider(value: $shadowRadius, in: 0...20)
                }
                
                VStack(alignment: .center, spacing: 30) {
                    Text("Ширина изображения (\(Int(imageWidth)))")
                        .fontWeight(.black)
                    Slider(value: $imageWidth, in: 100...300)
                }
                
                VStack(alignment: .center, spacing: 30) {
                    Text("Высота изображения (\(Int(imageHeight)))")
                        .fontWeight(.black)
                    Slider(value: $imageHeight, in: 100...300)
                }
                
                VStack(alignment: .center, spacing: 30) {
                    Text("Угол поворота изображения (\(Int(rotatingAngle)))")
                        .fontWeight(.black)
                    Slider(value: $rotatingAngle, in: 0...360)
                }
            }
        }.padding(30)
            .navigationTitle("Ячейка новости")
    }
}

#Preview {
    NewsSettingsOptionsListView()
}
