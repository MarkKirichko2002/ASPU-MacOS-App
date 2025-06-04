//
//  SelectedColorOptionCell.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 31.05.2025.
//

import SwiftUI
import MapKit

struct SelectedMapStyleOptionCell: View {
    
    @AppStorage("map style") var style = MapStyles.standard
    @State var camera = MapCameraPosition.automatic
    
    var body: some View {
        HStack(spacing: 15) {
            Map(position: $camera)
                .modifier(ImageShape())
                .mapStyle(style.style())
            
            VStack(alignment: .center, spacing: 30) {
                Text("Стиль карты")
                    .fontWeight(.black)
                Picker("", selection: $style) {
                    ForEach(MapStyles.allCases, id: \.self) { style in
                        Text(style.title)
                    }
                }.fontWeight(.black)
                .onChange(of: style) { oldValue, newValue in
                    NotificationCenter.default.post(name: Notification.Name("map style changed"), object: style)
                    style = newValue
                }
            }
        }.padding(30)
    }
}

#Preview {
    SelectedMapStyleOptionCell()
}
