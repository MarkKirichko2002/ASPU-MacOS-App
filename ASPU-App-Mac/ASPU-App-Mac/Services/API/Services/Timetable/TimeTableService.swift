//
//  TimeTableService.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Alamofire
import Foundation

final class TimeTableService {
    
    func getTimeTableDay(id: String, date: String, owner: String, completion: @escaping(Result<TimeTable,Error>)->Void) {
        
        let id = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host)/api/v2/timetable/day?id=\(id)&date=\(date)&owner=\(owner)").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode(TimeTable.self, from: data)
                print("Расписание: \(timetable)")
                completion(.success(timetable))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getTimeTableWeek(id: String, startDate: String, endDate: String, owner: String, completion: @escaping(Result<[TimeTable],Error>)->Void) {
        
        let id = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        AF.request("http://\(HostName.host)/api/v2/timetable/days?id=\(id)&startDate=\(startDate)&owner=\(owner)&endDate=\(endDate)&removeEmptyDays").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let timetable = try JSONDecoder().decode([TimeTable].self, from: data)
                print("Расписание: \(timetable)")
                completion(.success(timetable))
            } catch {
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
    
    func getWeeks(completion: @escaping(Result<[WeekModel],Error>)->Void) {
        
        AF.request("http://\(HostName.host)/api/v2/timetable/weeks").responseData { response in
            
            guard let data = response.data else {return}
            
            do {
                let weeks = try JSONDecoder().decode([WeekModel].self, from: data)
                print("Недели: \(weeks)")
                completion(.success(weeks))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
