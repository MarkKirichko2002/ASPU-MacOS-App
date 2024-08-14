//
//  SettingsManager.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

final class SettingsManager {
    
    func saveCategory(abbreviation: String) {
        UserDefaults.standard.setValue(abbreviation, forKey: "news category")
    }
    
    func getSavedCategory()-> String {
        let savedCategory = UserDefaults.standard.object(forKey: "news category") as? String ?? "-"
        return savedCategory
    }
    
    func getSavedID()-> String {
        return UserDefaults.standard.object(forKey: "id") as? String ?? "ВМ-ИВТ-2-1"
    }
    
    func getSavedOwner()-> String {
        return UserDefaults.standard.object(forKey: "owner") as? String ?? "GROUP"
    }
}
