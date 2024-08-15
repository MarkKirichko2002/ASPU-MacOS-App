//
//  AppNavigationView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import SwiftUI

enum appSections: String, Identifiable, CaseIterable {
    
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
    @State var selectedAppSection: appSections = .news
    
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
                    .foregroundStyle(Color("aspu"))
                    .onTapGesture {
                        selectedAppSection = item
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
                    }
                }
            }
        } content: {
            switch selectedAppSection {
            case .news:
                NewsListView()
            case .timetable:
                EmptyView()
            case .maps:
                BuildingsMapView()
            }
        } detail: {}
    }
}

#Preview {
    AppNavigationView()
}
