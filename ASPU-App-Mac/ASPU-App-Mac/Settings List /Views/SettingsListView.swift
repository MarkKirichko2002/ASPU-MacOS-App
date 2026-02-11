//
//  SettingsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 31.05.2025.
//

import SwiftUI

struct SettingsListView: View {
    
    @Environment(\.openWindow) var openWindow
    @State var isPresented = false
    @State var selectedSection = SettingSections.sections[0]
    
    var body: some View {
        List {
            Section(header: Text("Основное").font(.system(size: 15)).fontWeight(.black)) {
                ForEach(SettingSections.sections) { section in
                    HStack {
                        Image(section.icon)
                            .frame(width: 60, height: 60)
                        Text(section.name)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(10)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSection = section
                            isPresented.toggle()
                        }
                }
            }
        }.navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(alignment: .center) {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                        Text("Настройки")
                            .fontWeight(.black)
                    }
                }
            }
            .onChange(of: isPresented) {
                openWindow(id: selectedSection.windowID)
            }
    }
}

#Preview {
    SettingsListView()
}
