//
//  Discipline.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI

struct Discipline: Identifiable, Codable, Hashable {
    
    let id: String?
    let time: String
    let name, groupName, teacherName, audienceID: String
    let subgroup: Int
    let type: PairType

    enum CodingKeys: String, CodingKey {
        case id
        case time, name, groupName, teacherName
        case audienceID = "audienceId"
        case subgroup, type
    }
}

enum PairType: String, CaseIterable, Codable {
    case lec
    case prac
    case exam
    case lab
    case hol
    case cred
    case fepo
    case cons
    case cours
    case none
    case leftToday
    case all
    
    var title: String {
        switch self {
        case .lec:
            return "Лекция"
        case .prac:
            return "Практика"
        case .exam:
            return "Экзамен"
        case .lab:
            return "Лаб. работа"
        case .hol:
            return "Каникулы"
        case .cred:
            return "Зачет"
        case .fepo:
            return "ФЭПО"
        case .cons:
            return "Консультация"
        case .cours:
            return "Курсовая"
        case .none:
            return "Другое"
        case .leftToday:
            return "Оставшаяся"
        case .all:
            return "Все"
        }
    }
    
    var color: Color {
        switch self {
        case .lec:
            return Color("lecture")
        case .prac:
            return Color("prac")
        case .exam:
            return Color("exam")
        case .lab:
            return Color("lab")
        case .hol:
            return Color.white
        case .cred:
            return Color.white
        case .fepo:
            return Color.white
        case .cons:
            return Color.white
        case .cours:
            return Color.white
        case .none:
            return Color.white
        case .leftToday:
            return Color.white
        case .all:
            return Color.white
        }
    }
}
