//
//  TimetableWeekChartsView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import SwiftUI
import Charts

struct TimetableWeekChartsView: View {
    
    @StateObject var viewModel = TimetableWeekChartsViewModel()
    var id: String
    var owner: String
    var week: WeekModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.timetable.isEmpty {
                Text("Нет пар")
                    .fontWeight(.black)
            } else {
                makeCharts()
                    .padding()
            }
        }.navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(alignment: .center) {
                        Text("Неделя \(week.id): количество пар")
                            .fontWeight(.black)
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        Picker("Типы диаграмм", selection: $viewModel.currentChartType) {
                            ForEach(ChartTypes.allCases, id: \.self) { type in
                                Text(type.title)
                            }
                        }.onChange(of: viewModel.currentChartType) {}
                    } label: {
                        Image("sections")
                    }
                }
            }
            .onAppear {
                viewModel.getTimetable(id: id, owner: owner, week: week)
         }
    }
    
    @ViewBuilder
    func makeCharts()-> some View {
        switch viewModel.currentChartType {
        case .lineMark:
            Chart {
                ForEach(viewModel.timetable) { day in
                    LineMark(x: PlottableValue.value("Day", viewModel.titleForSection(date: day.date ?? "")),
                             y: .value("Pairs", day.getPairsCount()))
                    .annotation {
                        Text(String(day.getPairsCount()))
                            .fontWeight(.black)
                    }
                }
            }
        case .barMark:
            Chart {
                ForEach(viewModel.timetable) { day in
                    BarMark(x: PlottableValue.value("Day", viewModel.titleForSection(date: day.date ?? "")),
                             y: .value("Pairs", day.getPairsCount()))
                    .annotation {
                        Text(String(day.getPairsCount()))
                            .fontWeight(.black)
                    }
                }
            }
        case .pointMark:
            Chart {
                ForEach(viewModel.timetable) { day in
                    PointMark(x: PlottableValue.value("Day", viewModel.titleForSection(date: day.date ?? "")),
                             y: .value("Pairs", day.getPairsCount()))
                    .annotation {
                        Text(String(day.getPairsCount()))
                            .fontWeight(.black)
                    }
                }
            }
        case .areaMark:
            Chart {
                ForEach(viewModel.timetable) { day in
                    AreaMark(x: PlottableValue.value("Day", viewModel.titleForSection(date: day.date ?? "")),
                             y: .value("Pairs", day.getPairsCount()))
                    .annotation {
                        Text(String(day.getPairsCount()))
                            .fontWeight(.black)
                    }
                }
            }
        case .rectangleMark:
            Chart {
                ForEach(viewModel.timetable) { day in
                    RectangleMark(x: PlottableValue.value("Day", viewModel.titleForSection(date: day.date ?? "")),
                             y: .value("Pairs", day.getPairsCount()))
                    .annotation {
                        Text(String(day.getPairsCount()))
                            .fontWeight(.black)
                    }
                }
            }
        }
    }
}

//#Preview {
//    TimetableWeekChartsView()
//}
