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
    @EnvironmentObject var owner: TimetableOwner
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.timetable.disciplines.isEmpty {
                Text("Нет пар")
                    .fontWeight(.bold)
            } else {
                List(viewModel.timetable.disciplines, id: \.self) { pair in
                    PairCell(date: viewModel.timetable.date ?? "", discipline: pair)
                }
            }
        }
        .navigationTitle("Расписание \(viewModel.timetable.date ?? "")")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    Button {
                        openWindow(id: "search list")
                    } label: {
                        Text("Поиск")
                    }
                    Button {
                        viewModel.isPresented.toggle()
                    } label: {
                        Text("Дата")
                    }
                } label: {
                    Image("sections")
                }
            }
        }
        .onChange(of: viewModel.isDateSelected) {
            viewModel.getTimetable(for: viewModel.date)
        }
        .onChange(of: owner.result) { oldValue, newValue in
            viewModel.getTimetable(item: newValue)
        }
        .sheet(isPresented: $viewModel.isPresented) {
            VStack(spacing: 40) {
                Text("Выберите дату")
                    .fontWeight(.bold)
                DatePicker(selection: $viewModel.date) {
                    Text("")
                }
                Button(action: {
                    viewModel.isPresented = false
                    viewModel.isDateSelected.toggle()
                }) {
                    Text("Выбрать")
                }
            }.onChange(of: viewModel.date) { oldValue, newValue in
                print("\(viewModel.dateManager.getFormattedDate(date: newValue))")
            }
            .frame(width: 400, height: 400, alignment: .center)
        }
    }
}

#Preview {
    TimetableDayListView()
}
