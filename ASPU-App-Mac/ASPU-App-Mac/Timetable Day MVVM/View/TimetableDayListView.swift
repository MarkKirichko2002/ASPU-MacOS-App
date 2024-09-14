//
//  TimetableDayListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import SwiftUI

struct TimetableDayListView: View {
    
    @ObservedObject var viewModel = TimetableDayListViewModel()
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.timetable.disciplines.isEmpty {
                Text("Нет пар")
                    .fontWeight(.bold)
            } else {
                List(viewModel.timetable.disciplines, id: \.self) { pair in
                    PairCell(discipline: pair)
                        .onTapGesture {
                            viewModel.currentDiscipline = pair
                            viewModel.isSelected.toggle()
                      }
                }
            }
        }
        .navigationTitle("Расписание \(viewModel.timetable.date ?? "")")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Button {
                            openWindow(id: "weeks list")
                        } label: {
                            Text("Недели")
                        }
                    } label: {
                        Image("sections")
                    }
                }
            }
            .onChange(of: viewModel.date) { oldValue, newValue in
                viewModel.getTimetable(for: newValue)
            }
            .onAppear {
            if viewModel.isLoading {
               viewModel.getTimetable()
            }
         }
    }
}

#Preview {
    TimetableDayListView()
}
