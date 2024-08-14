//
//  TimeTable.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct TimeTable: Codable {
    
    let id: String?
    let date: String?
    var disciplines: [Discipline]
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "date"
        case disciplines = "disciplines"
    }
}
