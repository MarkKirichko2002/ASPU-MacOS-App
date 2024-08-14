//
//  NewsCategories.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct NewsCategories {
    
    static var categories = [
        NewsCategoryModel(id: 1, name: "АГПУ", abbreviation: "-", isSelected: false),
        NewsCategoryModel(id: 2, name: "Технопарк", abbreviation: "educationaltechnopark", isSelected: false),
        NewsCategoryModel(id: 3, name: "Кванториум", abbreviation: "PedagogicalQuantorium", isSelected: false),
        NewsCategoryModel(id: 4, name: "ФилФак", abbreviation: "filfak", isSelected: false),
        NewsCategoryModel(id: 5, name: "ФМФ", abbreviation: "fmf", isSelected: false),
        NewsCategoryModel(id: 6, name: "ППФ", abbreviation: "ppf", isSelected: false),
        NewsCategoryModel(id: 7, name: "ФТиФК", abbreviation: "ftifk", isSelected: false),
        NewsCategoryModel(id: 8, name: "ИСТФАК", abbreviation: "istfak", isSelected: false),
    ]
}
