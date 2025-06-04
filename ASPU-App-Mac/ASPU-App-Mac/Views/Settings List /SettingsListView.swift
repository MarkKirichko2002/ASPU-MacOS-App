//
//  SettingsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 31.05.2025.
//

import SwiftUI

struct SettingsListView: View {
    
    var body: some View {
        List {
            Section(header: Text("Внешний вид").font(.system(size: 15)).fontWeight(.black)) {
                NewsSettingsOptionCell()
                SelectedMapStyleOptionCell()
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
    }
}

#Preview {
    SettingsListView()
}
