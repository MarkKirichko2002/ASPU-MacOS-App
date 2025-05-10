//
//  TimetableOwner.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 10.05.2025.
//

import Foundation

class TimetableOwner: ObservableObject {
    @Published var result = SearchResultModel(searchContent: "", searchID: 0, ownerID: 0, type: .Group)
}
