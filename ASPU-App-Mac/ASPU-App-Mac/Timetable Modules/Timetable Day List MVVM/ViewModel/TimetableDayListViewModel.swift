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
    @Published var currentType = PairType.all
    @Published var viewModel = TimetableViewModel(id: "", owner: "", date: Date())
    
    var allDisciplines = [Discipline]()
    
    // MARK: - сервисы
    private let service = TimeTableService()
    private let settingsManager = SettingsManager()
    private let dateManager = DateManager()
    
    func getTimetable() {
        isLoading = true
        currentType = .all
        service.getTimeTableDay(id: settingsManager.getSavedID(), date: dateManager.getFormattedDate(date: date), owner: settingsManager.getSavedOwner()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.allDisciplines = data.disciplines
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
        updateTimetableViewModel()
    }
    
    func getTimetable(item: TimetableViewModel) {
        isLoading = true
        currentType = .all
        settingsManager.saveTimetableID(id: item.id)
        settingsManager.saveTimetableOwner(owner: item.owner)
        service.getTimeTableDay(id: item.id, date: dateManager.getFormattedDate(date: item.date), owner: item.owner) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.allDisciplines = data.disciplines
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
        updateTimetableViewModel()
    }
    
    func getTimetable(for date: Date) {
        isLoading = true
        currentType = .all
        self.date = date
        service.getTimeTableDay(id: settingsManager.getSavedID(), date: dateManager.getFormattedDate(date: date), owner: settingsManager.getSavedOwner()) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.timetable = data
                    self.allDisciplines = data.disciplines
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
        updateTimetableViewModel()
    }
    
    func pairTypeInfo(type: PairType)-> String {
        return "\(type.title) (\(countForPairType(type: type)))"
    }
    
    func countForPairType(type: PairType)-> Int {
        
        var filteredData = [Discipline]()
        var uniqueTimes: Set<String> = Set()
        
        if allDisciplines.isEmpty {
            allDisciplines = timetable.disciplines
        }
        
        if type != .all {
            filteredData = type == .leftToday ? filterLeftedPairs(pairs: allDisciplines) : allDisciplines.filter({ $0.type == type })
        } else {
            filteredData = allDisciplines
        }
        
        for pair in filteredData {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
        
    }
    
    func filterLeftedPairs(pairs: [Discipline])-> [Discipline] {
        
        var disciplines = [Discipline]()
        
        let currentDate = dateManager.getCurrentDate()
        let currentTime = dateManager.getCurrentTime(isFullFormat: true)
        
        for pair in pairs {
            
            let pairEndTime = "\(pair.time.components(separatedBy: "-")[1]):00"
            
            let timetableDate = dateManager.getFormattedDate(date: date)
            
            let compareDate = dateManager.compareDates(date1: timetableDate, date2: currentDate)
            let compareTime = dateManager.compareTimes(time1: pairEndTime, time2: currentTime)
            
            // прошлый день
            if compareDate == .orderedAscending {
                return disciplines
            }
            
            // время больше и тот же день
            if compareTime == .orderedDescending && compareDate == .orderedSame {
                disciplines.append(pair)
            }
            
            // следующий день
            if compareDate == .orderedDescending {
                return allDisciplines
            }
        }
        
        return disciplines
    }
    
    func filterDisciplines(type: PairType)-> [Discipline] {
        
        currentType = type
        
        var disciplines = timetable.disciplines
        
        if type == .all {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = disciplines
            }
            
            disciplines = self.allDisciplines
            
        } else if type == .leftToday {
            
            let filteredDisciplines = self.filterLeftedPairs(pairs: self.allDisciplines)
            disciplines = filteredDisciplines
            
        } else {
            
            if self.allDisciplines.isEmpty {
                self.allDisciplines = disciplines
            }
            
            let filteredDisciplines = self.allDisciplines.filter { $0.type == type }
            return filteredDisciplines
        }
        
        return disciplines
    }
    
    func updateTimetableViewModel() {
        viewModel = TimetableViewModel(id: settingsManager.getSavedID(), owner: settingsManager.getSavedOwner(), date: date)
    }
    
    func makeNavigationTitle()-> String {
        let formattedDate = dateManager.getFormattedDate(date: date)
        let daysOfWeek = dateManager.getCurrentDayOfWeek(date: formattedDate)
        if isLoading {
            return "Загрузка..."
        } else {
            return "\(daysOfWeek) \(formattedDate)"
        }
    }
    
    func getSavedID()-> String {
        return settingsManager.getSavedID()
    }
    
    func getSavedOwner()-> String {
        return settingsManager.getSavedOwner()
    }
    
    func getCurrentDate()-> String {
        return dateManager.getCurrentDate()
    }
}
