//
//  WeekParser.swift
//  ASPU-App-Watch Watch App
//
//  Created by Марк Киричко on 10.09.2025.
//

import Foundation
import SwiftSoup

class GetWeeksService {
    
    static let shared = GetWeeksService()
    
    let dateManager = DateManager()
    
    func collectWeeks()-> [WeekModel] {
        
        var weeks: [WeekModel] = []
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 9
        components.day = 1
        components.year = 2025
        
        guard let firstSeptember = calendar.date(from: components) else { return weeks}
        
        // Ищем первый понедельник сентября
        var firstWeekStart = firstSeptember
        while calendar.component(.weekday, from: firstWeekStart) != 2 { // 2 - понедельник
            firstWeekStart = calendar.date(byAdding: .day, value: 1, to: firstWeekStart)!
        }
        
        // Проверяем, если в этой неделе есть будние дни сентября
        var foundWeekStart: Date? = nil
        while foundWeekStart == nil {
            //let weekEnd = calendar.date(byAdding: .day, value: 6, to: firstWeekStart)!
            
            let weekdaysInSeptember = (0...6).contains { day in
                let currentDay = calendar.date(byAdding: .day, value: day, to: firstWeekStart)!
                return calendar.component(.month, from: currentDay) == 9
            }
            
            if weekdaysInSeptember {
                foundWeekStart = firstWeekStart
            } else {
                firstWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: firstWeekStart)!
            }
        }
        
        components.year! += 1
        components.month = 7
        components.day = 5
        guard let lastAugustNextYear = calendar.date(from: components) else { return weeks }
        let lastWeekEnd = calendar.date(byAdding: .day, value: 6 - calendar.component(.weekday, from: lastAugustNextYear), to: lastAugustNextYear)!
        
        // Заполняем список недель
        var current = foundWeekStart!
        var weekId = 1
        
        while current <= lastWeekEnd {
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: current)!
            
            let startDate = dateManager.getFormattedDate(date: current)
            let endDate = dateManager.getFormattedDate(date: weekEnd <= lastWeekEnd ? weekEnd : lastWeekEnd)
            
            var weekDTO = WeekModel(id: weekId, from: startDate, to: endDate, dayNames: [:])
            
            weekDTO.dayNames = dateManager.fillDay(from: weekDTO.from)
            
            weeks.append(weekDTO)
            
            // Переходим к следующей неделе
            current = calendar.date(byAdding: .weekOfYear, value: 1, to: current)!
            weekId += 1
        }
                
        return weeks
    }
}
