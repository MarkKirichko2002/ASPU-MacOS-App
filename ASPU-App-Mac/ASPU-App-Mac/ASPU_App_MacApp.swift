//
//  ASPU_App_MacApp.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI

@main
struct ASPU_App_MacApp: App {
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
        }
        Window("Информация о паре", id: "pair info") {
            Text("New in this version…")
        }
        
        Window("", id: "weeks list") {
           WeeksListView()
        }
    }
}
