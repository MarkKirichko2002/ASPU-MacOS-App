//
//  TimeTableService.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Alamofire
import Foundation

final class TimeTableService {
    
    func getSearchResults(searchText: String, completion: @escaping(Result<[SearchResultModel],Error>)->Void) {
        
        AF.request("https://it-institut.ru/SearchString/KeySearch?Id=118&SearchProductName=\(searchText)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let results = try JSONDecoder().decode([SearchResultModel].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTimeTableDay(id: String, date: String, owner: String, completion: @escaping (Result<TimeTable, Error>) -> Void) {
        Task {
            do {
                guard let timetableOwner = TimetableOwner(rawValue: owner.capitalized) else {
                    throw NSError(domain: "InvalidOwner", code: 0)
                }
                
                let days = try await GetTimetableService.shared.getDisciplines(
                    id: id,
                    owner: timetableOwner,
                    startDate: date,
                    endDate: date
                )
                
                guard let day = days.first else {
                    throw NSError(domain: "NoData", code: 0)
                }
                
                let timetable = TimeTable(id: day.owner?.rawValue ?? "", date: day.date, disciplines: day.lessons.map({ Discipline(time: $0.time ?? "", name: $0.name ?? "", groupName: $0.groupName ?? "", teacherName: $0.teacherName ?? "", audienceID: $0.audienceId ?? "", subgroup: $0.subgroup, type: $0.type)
                    
                }))
                
                completion(.success(timetable))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTimeTableWeek(id: String, startDate: String, endDate: String, owner: String, completion: @escaping (Result<[TimeTable], Error>) -> Void) {
        // Маппинг строки owner в TimetableOwner
        guard let timetableOwner = TimetableOwner(rawValue: owner.capitalized) else {
            let error = NSError(domain: "TimetableError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid owner type: \(owner)"])
            completion(.failure(error))
            return
        }
        
        // Вызываем getDisciplines из GetTimetableService
        Task {
            do {
                let timetableDays = try await GetTimetableService.shared.getDisciplines(
                    id: id,
                    owner: timetableOwner,
                    startDate: startDate,
                    endDate: endDate
                )
                
                // Преобразуем [TimetableDay] в [TimeTable]
                var timeTables = timetableDays.map { TimeTable(id: $0.owner?.rawValue ?? "", date: $0.date, disciplines: $0.lessons.map({ Discipline(time: $0.time ?? "", name: $0.name ?? "", groupName: $0.groupName ?? "", teacherName: $0.teacherName ?? "", audienceID: $0.audienceId ?? "", subgroup: $0.subgroup, type: $0.type)
                    
                })) }
                
                timeTables = timeTables.filter { !$0.disciplines.isEmpty }
                completion(.success(timeTables))
            } catch {
                print("Error fetching timetable: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getGroups(completion: @escaping(Result<[FacultyModel],Error>)->Void) {
        
        AF.request("http://\(HostName.host)/api/v2/timetable/groups").responseData { response in
        
            guard let data = response.data else {return}
            
            do {
                let groups = try JSONDecoder().decode([FacultyModel].self, from: data)
                print("Группы: \(groups)")
                completion(.success(groups))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getWeeks(completion: @escaping (Result<[WeekModel], Error>) -> Void) {
        completion(.success(GetWeeksService.shared.collectWeeks()))
    }
}
