//
//  Article.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

struct Article: Identifiable, Codable {
    let id: Int
    let title: String?
    let description: String?
    let date: String?
    let previewImage: String?
}
