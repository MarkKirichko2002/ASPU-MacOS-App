//
//  WeekIdService.swift
//  ASPU-App-Watch Watch App
//
//  Created by Марк Киричко on 10.09.2025.
//

import Foundation

final class WeekIdService {
    
    static func weekIdByDate(_ date: String) -> Int64 {
        guard let mapping = AppConfig.getWeekIdMappings().first(where: {
            let parts = $0.range.split(separator: "-").map { String($0) }
            return dateInRange(startDate: parts[0], endDate: parts[1], target: date)
        }) else {
            return 1
        }
        
        let parts = mapping.range.split(separator: "-").map { String($0) }
        guard parts.count == 2 else { return 1 }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        guard let start = formatter.date(from: parts[0]),
              let targetDate = formatter.date(from: date) else {
            return 1
        }
        
        let mappingWeekId = mapping.id
        let mappingWeek = Int64(start.timeIntervalSince1970 / 86400)
        let currentWeek = Int64(targetDate.timeIntervalSince1970 / 86400)
        
        let countDays = currentWeek - mappingWeek
        return mappingWeekId + (countDays / 7)
    }
    
    private static func dateInRange(startDate: String, endDate: String, target: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        guard let start = formatter.date(from: startDate),
              let end = formatter.date(from: endDate),
              let targetDate = formatter.date(from: target) else {
            return false
        }
        
        var dateCursor = start
        while dateCursor <= end {
            if Calendar.current.isDate(dateCursor, inSameDayAs: targetDate) {
                return true
            }
            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: dateCursor) else {
                break
            }
            dateCursor = nextDay
        }
        return false
    }
}


