//
//  TimetableWeekChartsViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import Charts
import SwiftUI

final class TimetableWeekChartsViewModel: ObservableObject {
    
    @Published var timetable = [TimeTable]()
    @Published var isLoading = true
    @Published var currentChartType = ChartTypes.barMark
    
    // MARK: - сервисы
    private let timeTableService = TimeTableService()
    private let dateManager = DateManager()
    
    func getTimetable(id: String, owner: String, week: WeekModel) {
        isLoading = true
        print("\(week)")
        timeTableService.getTimeTableWeek(id: id, startDate: week.from, endDate: week.to, owner: owner) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.timetable = data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
    
    func titleForSection(date: String)-> String {
        let dayOfWeek = dateManager.getCurrentDayOfWeek(date: date)
        return "\(dayOfWeek) \(date)"
    }
}
