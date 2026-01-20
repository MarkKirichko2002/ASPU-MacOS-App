//
//  SettingSectionModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 20.01.2026.
//

import Foundation

struct SettingSectionModel: Identifiable {
    let id = UUID()
    let windowID: String
    let icon: String
    let name: String
}

struct SettingSections {
    static let sections = [
        SettingSectionModel(windowID: "news cell", icon: "mail", name: "Новости"),
        SettingSectionModel(windowID: "maps", icon: "map", name: "Карты"),
    ]
}
