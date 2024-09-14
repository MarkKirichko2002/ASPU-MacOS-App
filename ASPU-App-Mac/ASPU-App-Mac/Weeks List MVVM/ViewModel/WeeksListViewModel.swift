//
//  WeeksListViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.09.2024.
//

import Foundation

final class WeeksListViewModel: ObservableObject {
    
    @Published var weeks = [WeekModel]()
    @Published var currentWeek = WeekModel(id: 1, from: "", to: "", dayNames: ["" : ""])
    @Published var isPresented = false
    @Published var isSelected = false
    @Published var isLoading = false
    
    // MARK: - сервисы
    private let service = TimeTableService()
    
    func getWeeks() {
        isLoading = true
        service.getWeeks { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.weeks = data
                    self.isLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
}
