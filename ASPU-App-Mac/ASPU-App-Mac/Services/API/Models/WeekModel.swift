//
//  WeekModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct WeekModel: Identifiable, Codable {
    let id: Int
    let from, to: String
    let dayNames: [String: String]
}
