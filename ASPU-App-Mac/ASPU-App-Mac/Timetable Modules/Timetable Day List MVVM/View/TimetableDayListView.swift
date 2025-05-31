//
//  TimetableDayListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import SwiftUI

struct TimetableDayListView: View {
    
    @StateObject var viewModel: TimetableDayListViewModel
    @Environment(\.openWindow) var openWindow
    @EnvironmentObject var storage: TimetableStorage
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.timetable.disciplines.isEmpty {
                Text("Нет пар")
                    .fontWeight(.black)
            } else {
                List(viewModel.timetable.disciplines, id: \.self) { pair in
                    PairCell(date: viewModel.timetable.date ?? "", discipline: pair)
                }
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    viewModel.getTimetable()
                }) {
                    Image("refresh icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 23, height: 23)
                        .foregroundStyle(Color.primary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack(alignment: .center) {
                    Image("clock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                    Text(viewModel.makeNavigationTitle())
                        .fontWeight(.black)
                }
            }
            
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
                    Button {
                        openWindow(id: "days list")
                    } label: {
                        Text("Список дней")
                    }
                    Button {
                        openWindow(id: "weeks list")
                    } label: {
                        Text("Недели")
                    }
                    Picker("Фильтрация", selection: $viewModel.currentType) {
                        ForEach(PairType.allCases, id: \.self) { type in
                            Text(viewModel.pairTypeInfo(type: type))
                        }
                        .onChange(of: viewModel.currentType) { oldValue, newValue in
                            viewModel.timetable.disciplines = viewModel.filterDisciplines(type: newValue)
                        }
                    }
                } label: {
                    Image("sections")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color(.labelColor))
                }
            }
        }
        .onChange(of: viewModel.isDateSelected) {
            viewModel.getTimetable(for: viewModel.date)
        }
        .onChange(of: storage.viewModel.owner) { oldValue, newValue in
            viewModel.getTimetable(item: storage.viewModel)
        }
        .onChange(of: storage.viewModel.date) { date in
            viewModel.getTimetable(for: date)
        }
        .sheet(isPresented: $viewModel.isPresented) {
            VStack(spacing: 40) {
                Text("Выберите дату")
                    .fontWeight(.black)
                DatePicker(selection: $viewModel.date) {
                    Text("")
                }
                Button(action: {
                    viewModel.isPresented = false
                    viewModel.isDateSelected.toggle()
                }) {
                    Text("Выбрать")
                }
            }
            .frame(width: 400, height: 400, alignment: .center)
        }
        .onChange(of: viewModel.viewModel) {
            setUpStorage()
        }
        .onAppear {
            if viewModel.isLoading {
                viewModel.getTimetable()
            }
        }
    }
    
    func setUpStorage() {
        storage.viewModel = viewModel.viewModel
    }
}

//#Preview {
//    TimetableDayListView()
//}
