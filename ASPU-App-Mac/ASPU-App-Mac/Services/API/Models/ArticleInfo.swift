//
//  ArticleInfo.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

struct ArticleInfo: Codable {
    let id: Int?
    let title, description, date: String
    let images: [String]
}
