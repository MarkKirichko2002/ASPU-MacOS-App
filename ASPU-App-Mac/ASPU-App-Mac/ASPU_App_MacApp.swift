//
//  ASPU_App_MacApp.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI

@main
struct ASPU_App_MacApp: App {
    
    @StateObject var storage = TimetableStorage()
    
    var body: some Scene {
        WindowGroup {
            AppNavigationView()
                .environmentObject(storage)
        }
        Window("", id: "search list") {
            SearchResultsListView()
                .environmentObject(storage)
        }
        Window("", id: "weeks list") {
            WeeksListView()
                .environmentObject(storage)
        }
        Window("", id: "timetable week") {
            TimetableWeekListView(id: storage.viewModel.id, owner: storage.viewModel.owner, week: storage.currentWeek)
                .environmentObject(storage)
        }
        Window("", id: "timetable week charts") {
            TimetableWeekChartsView(id: storage.viewModel.id, owner: storage.viewModel.owner, week: storage.currentWeek)
                .environmentObject(storage)
        }
        Window("", id: "days list") {
            DaysListView(viewModel: DaysListViewModel(id: storage.viewModel.id, currentDate: storage.viewModel.date, owner: storage.viewModel.owner))
                .environmentObject(storage)
        }
    }
}
