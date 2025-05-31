//
//  TimetableWeekListViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 21.05.2025.
//

import Foundation

final class TimetableWeekListViewModel: ObservableObject {
    
    @Published var timetable = [TimeTable]()
    @Published var isLoading = true
    
    // MARK: - сервисы
    private let timeTableService = TimeTableService()
    private let dateManager = DateManager()
    
    func getTimetable(id: String, owner: String, week: WeekModel) {
        isLoading = true
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
