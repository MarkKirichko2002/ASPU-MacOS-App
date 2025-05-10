//
//  TimetableDayListViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import Foundation

final class TimetableDayListViewModel: ObservableObject {
    
    @Published var timetable = TimeTable(id: "", date: "", disciplines: [])
    @Published var date = Date()
    @Published var isLoading = true
    @Published var isPresented = false
    @Published var isPresentedInfo = false
    @Published var isDateSelected = false
    
    // MARK: - сервисы
    private let service = TimeTableService()
    private let settingsManager = SettingsManager()
    let dateManager = DateManager()
    
    func getTimetable() {
        isLoading = true
        service.getTimeTableDay(id: settingsManager.getSavedID(), date: dateManager.getFormattedDate(date: date), owner: settingsManager.getSavedOwner()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
    
    func getTimetable(item: SearchResultModel) {
        isLoading = true
        settingsManager.saveTimetableID(id: item.searchContent)
        settingsManager.saveTimetableOwner(owner: item.type.rawValue.getOwner())
        service.getTimeTableDay(id: item.searchContent, date: dateManager.getFormattedDate(date: date), owner: item.type.rawValue.getOwner()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
    
    func getTimetable(for date: Date) {
        isLoading = true
        service.getTimeTableDay(id: settingsManager.getSavedID(), date: dateManager.getFormattedDate(date: date), owner: settingsManager.getSavedOwner()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.timetable.disciplines = []
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
    
    func getCurrentDate()-> String {
        return dateManager.getCurrentDate()
    }
}
