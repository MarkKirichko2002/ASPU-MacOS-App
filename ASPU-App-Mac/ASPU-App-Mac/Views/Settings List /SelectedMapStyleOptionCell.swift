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
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .mapStyle(style.style())
            Picker("Стиль карты", selection: $style) {
                ForEach(MapStyles.allCases, id: \.self) { style in
                    Text(style.title)
                }
            }.fontWeight(.black)
            .onChange(of: style) { oldValue, newValue in
                NotificationCenter.default.post(name: Notification.Name("map style changed"), object: style)
                style = newValue
            }
        }.padding(30)
            .border(.primary, width: 3)
    }
}

#Preview {
    SelectedMapStyleOptionCell()
}
