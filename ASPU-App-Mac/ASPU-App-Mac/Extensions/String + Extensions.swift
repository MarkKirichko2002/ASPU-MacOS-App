//
//  String + Extensions.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 10.05.2025.
//

import Foundation

extension String {
    
    func getOwner()-> Self {
        if self == "Group" {
            return "GROUP"
        } else if self == "Teacher" {
            return "TEACHER"
        } else if self == "Classroom" {
            return "CLASSROOM"
        }
        return ""
    }
}
