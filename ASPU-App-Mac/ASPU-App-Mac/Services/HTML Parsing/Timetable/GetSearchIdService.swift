//
//  GetSearchIdService.swift
//  ASPU-App-Watch Watch App
//
//  Created by Марк Киричко on 10.09.2025.
//

import Foundation
import SwiftSoup

// MARK: - SearchResultModel
struct SearchResultModel: Codable {
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

final class GetSearchIdService {
    static let shared = GetSearchIdService()
    
    private let urlTemplate = "http://it-institut.ru/SearchString/KeySearch?Id=118&SearchProductName=%@"
    private let urlToMainPage = "http://it-institut.ru/SearchString/Index/118"
    
    private init() {}
    
    // MARK: - Public API
    func getSearchId(searchText: String, owner: TimetableOwner) async throws -> Int {
        switch owner {
        case .group:
            let checked = checkFirstLetter(searchText) // нужно переписать checkFirstLetter
            return try await getSearchIdByType(searchText: checked, expectedType: "Group")
        case .teacher:
            return try await getSearchIdByType(searchText: searchText, expectedType: "Teacher")
        case .classroom:
            return try await getSearchIdByType(searchText: searchText, expectedType: "Classroom")
        }
    }
    
    func getFullGroupName(_ groupName: String) async throws -> String {
        return try await getSearchContent(searchText: groupName, expectedType: "Group")
    }
    
    func getSearchContent(searchText: String, expectedType: String) async throws -> String {
        let result = try await fetchSearchProducts(searchString: searchText)
        return result.first(where: { $0.type.rawValue == expectedType })?.searchContent ?? "None"
    }
    
    func getAllGroupsFromMainPage() async throws -> [FacultyModel] {
        let html = try await fetchString(from: urlToMainPage)
        let doc = try SwiftSoup.parse(html)
        let cards = try doc.getElementsByClass("card")
        
        var result: [FacultyModel] = []
        for card in cards.array() {
            result.append(try parseCardElement(card))
        }
        return result
    }
    
    // MARK: - Private
    private func getSearchIdByType(searchText: String, expectedType: String) async throws -> Int {
        let result = try await fetchSearchProducts(searchString: searchText)
        return result.first(where: { $0.type.rawValue == expectedType })?.searchID ?? 0
    }
    
    private func fetchSearchProducts(searchString: String) async throws -> [SearchResultModel] {
        let encoded = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchString
        let urlStr = String(format: urlTemplate, encoded)
        guard let url = URL(string: urlStr) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode([SearchResultModel].self, from: data)
    }
    
    private func fetchString(from url: String) async throws -> String {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let text = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return text
    }
    
    private func parseCardElement(_ cardElement: Element) throws -> FacultyModel {
        let facultyName = try cardElement.getElementsByTag("button").first()?.text() ?? ""
        let groupElements = try cardElement.getElementsByClass("p-2")
        
        var groups: [String] = []
        for element in groupElements.array() {
            groups.append(try element.text())
        }
        
        return FacultyModel(facultyName: facultyName, groups: groups)
    }
    
    // MARK: - Ported helper
    private func checkFirstLetter(_ input: String) -> String {
        guard let first = input.first else { return input }
        return first.uppercased() + input.dropFirst()
    }
}

