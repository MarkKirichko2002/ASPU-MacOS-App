//
//  ASPU_App_MacApp.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI

@main
struct ASPU_App_MacApp: App {
    
    @StateObject var owner = TimetableOwner()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(owner)
        }
        Window("", id: "weeks list") {
           WeeksListView()
        }
        
        Window("", id: "search list") {
            SearchResultsListView()
                .environmentObject(owner)
        }
    }
}
