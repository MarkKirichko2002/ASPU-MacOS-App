//
//  TimetableStorage.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 10.05.2025.
//

import Foundation

class TimetableStorage: ObservableObject {
    @Published var viewModel = TimetableViewModel(id: "", owner: "", date: Date())
    @Published var currentWeek = WeekModel(id: 0, from: "", to: "", dayNames: [:])
}
