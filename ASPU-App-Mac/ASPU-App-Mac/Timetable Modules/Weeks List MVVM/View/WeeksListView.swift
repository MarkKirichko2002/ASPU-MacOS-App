//
//  WeeksListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.09.2024.
//

import SwiftUI

struct WeeksListView: View {
    
    @StateObject var viewModel = WeeksListViewModel()
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var storage: TimetableStorage
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Загрузка...")
                    .fontWeight(.black)
            } else if !viewModel.weeks.isEmpty {
                List(viewModel.weeks) { week in
                    WeekCell(week: week)
                    .onTapGesture {
                        storage.currentWeek = week
                        viewModel.isSelected.toggle()
                    }
                    .contextMenu {
                        Button(action: {
                            storage.currentWeek = week
                            viewModel.isChartsSelected.toggle()
                        }) {
                            HStack {
                                Image("charts")
                                Text("График")
                                    .fontWeight(.black)
                            }
                        }
                    }
                }
            } else {
                Text("Нет недель")
                    .fontWeight(.black)
            }
        }
        .navigationTitle("Недели")
        .onAppear() {
            viewModel.getWeeks()
        }
        .onChange(of: viewModel.isSelected) {
            openWindow(id: "timetable week")
        }
        .onChange(of: viewModel.isChartsSelected) {
            openWindow(id: "timetable week charts")
        }
    }
}

#Preview {
    WeeksListView()
}
