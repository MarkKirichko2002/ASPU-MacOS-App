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
    @State var isPresented = false
    
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
                    Button {
                        isPresented.toggle()
                    } label: {
                        Text("Дата")
                    }
                } label: {
                    Image("sections")
                }
            }
        }
        .onChange(of: viewModel.date) { oldValue, newValue in
            viewModel.getTimetable(for: newValue)
        }
        .sheet(isPresented: $viewModel.isSelected) {
            PairInfoView(viewModel: PairInfoViewModel(pair: viewModel.currentDiscipline, date: viewModel.getCurrentDate()))
        }
        .sheet(isPresented: $isPresented) {
            DatePicker(selection: $viewModel.date) {
                Text("")
            }.frame(width: 200, height: 200, alignment: .center)
                .onChange(of: viewModel.date) {
                    self.isPresented.toggle()
                }
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
