//
//  FacultyModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct FacultyModel: Codable, Identifiable {
    let id = UUID()
    let facultyName: String
    let groups: [String]
}
