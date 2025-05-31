//
//  TimetableWeekListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 21.05.2025.
//

import SwiftUI

struct TimetableWeekListView: View {
    
    @StateObject var viewModel = TimetableWeekListViewModel()
    var id: String
    var owner: String
    var week: WeekModel
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.timetable.isEmpty {
                Text("Нет пар")
                    .fontWeight(.black)
            } else {
                List {
                    ForEach(viewModel.timetable, id: \.self) { day in
                        Section(header: Text(viewModel.titleForSection(date: day.date ?? "")).font(.system(size: 16))) {
                            ForEach(day.disciplines, id: \.self) { discipline in
                                PairCell(date: day.date ?? "", discipline: discipline)
                            }
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.getTimetable(id: id, owner: owner, week: week)
        }
    }
}

//#Preview {
//    TimetableWeekListView()
//}
