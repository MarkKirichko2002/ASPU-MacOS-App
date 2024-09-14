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
    
    var icon: String {
        switch self {
        case .news:
            return "mail"
        case .timetable:
            return "clock"
        case .maps:
            return "map"
        }
    }
}

struct AppNavigationView: View {
    
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedAppSection = UserDefaults.loadData(type: appSections.self, key: "section") ?? appSections.news
    
    let newsListView = NewsListView()
    let timetableDayListView = TimetableDayListView()
    let buildingsMapView = BuildingsMapView()

    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(appSections.allCases, selection: $selectedAppSection) { item in
                if selectedAppSection == item {
                    HStack {
                        Image("\(item.icon) selected")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(item.rawValue)
                            .fontWeight(.bold)
                    }.padding(10)
                    .onTapGesture {
                        selectedAppSection = item
                        UserDefaults.saveData(object: item, key: "section") {}
                    }
                } else {
                    HStack {
                        Image(item.icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text(item.rawValue)
                            .fontWeight(.bold)
                    }.padding(10)
                    .onTapGesture {
                        selectedAppSection = item
                        UserDefaults.saveData(object: item, key: "section") {}
                    }
                }
            }
        } content: {
            switch selectedAppSection {
            case .news:
                newsListView
            case .timetable:
                timetableDayListView
            case .maps:
                buildingsMapView
            }
        } detail: {}
    }
}

#Preview {
    AppNavigationView()
}
