//
//  NewsCategoryModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct NewsCategoryModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let abbreviation: String
    var isSelected: Bool
}

