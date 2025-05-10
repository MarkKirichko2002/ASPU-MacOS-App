//
//  SearchResultModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 24.09.2024.
//

import Foundation

// MARK: - SearchResultModel
struct SearchResultModel: Codable, Equatable {
    let searchContent: String
    let searchID, ownerID: Int
    let type: SearchType

    enum CodingKeys: String, CodingKey {
        case searchContent = "SearchContent"
        case type = "Type"
        case searchID = "SearchId"
        case ownerID = "OwnerId"
    }
}

enum SearchType: String, Codable {
    case Teacher
    case Group
    case Classroom
}
