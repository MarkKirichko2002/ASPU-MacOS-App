//
//  WeeksListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.09.2024.
//

import SwiftUI

struct WeeksListView: View {
    
    @ObservedObject var viewModel = WeeksListViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Загрузка...")
                    .fontWeight(.bold)
            } else if !viewModel.weeks.isEmpty {
                List(viewModel.weeks) { week in
                    WeekCell(week: week)
                        .onTapGesture {
                            viewModel.currentWeek = week
                            viewModel.isSelected.toggle()
                     }
                }
            } else {
                Text("Нет недель")
                    .fontWeight(.bold)
            }
        }
        .navigationTitle("Недели")
        .onAppear() {
            viewModel.getWeeks()
        }
        .onChange(of: viewModel.isSelected) {
            viewModel.isPresented.toggle()
        }
        .sheet(isPresented: $viewModel.isPresented, content: {
            //WeekDaysListView(week: viewModel.currentWeek)
        })
    }
}

#Preview {
    WeeksListView()
}
