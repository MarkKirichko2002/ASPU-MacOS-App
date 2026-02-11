//
//  AppNavigationView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import SwiftUI

enum appSections: String, Codable, Identifiable, CaseIterable {
    
    var id: String { rawValue }
    
    case news = "Новости"
    case timetable = "Расписание"
    case maps = "Карты"
    case settings = "Настройки"
    
    var icon: String {
        switch self {
        case .news:
            return "mail"
        case .timetable:
            return "clock"
        case .maps:
            return "map"
        case .settings:
            return "settings"
        }
    }
}

struct AppNavigationView: View {
    
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedAppSection = UserDefaults.loadData(type: appSections.self, key: "section") ?? appSections.news
    
    @StateObject var newsListViewModel = NewsListViewModel()
    @StateObject var timetableViewModel = TimetableDayListViewModel()
    @StateObject var buildingsMapViewModel = BuildingsMapViewModel()
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(appSections.allCases, selection: $selectedAppSection) { item in
                HStack {
                    Image(selectedAppSection == item ? "\(item.icon) selected" : item.icon)
                        .resizable()
                        .frame(width: 32, height: 32)
                    Text(item.rawValue)
                        .fontWeight(.black)
                }.padding(10)
                    .onTapGesture {
                        selectedAppSection = item
                        UserDefaults.saveData(object: item, key: "section") {}
                    }
            }
        } content: {
            switch selectedAppSection {
            case .news:
                NewsListView(viewModel: newsListViewModel)
            case .timetable:
                TimetableDayListView(viewModel: timetableViewModel)
            case .maps:
                BuildingsMapView(viewModel: buildingsMapViewModel)
            case .settings:
                SettingsListView()
            }
        } detail: {}
    }
}

#Preview {
    AppNavigationView()
}
