//
//  ChartTypes.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import Foundation

enum ChartTypes: String, Codable, CaseIterable, Hashable {
    case lineMark
    case barMark
    case pointMark
    case areaMark
    case rectangleMark
    
    var title: String {
        switch self {
        case .lineMark:
            return "Линейный график"
        case .barMark:
            return "Гистограмма (столбцы)"
        case .pointMark:
            return "Точечный график"
        case .areaMark:
            return "Площадной график"
        case .rectangleMark:
            return "Прямоугольники"
        }
    }
}
