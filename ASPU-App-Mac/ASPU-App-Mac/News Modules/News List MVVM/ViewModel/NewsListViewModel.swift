//
//  NewsListViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

final class NewsListViewModel: ObservableObject {
    
    @Published var newsResponse = NewsResponse(currentPage: 0, countPages: 0, articles: [])
    @Published var isPresented = false
    @Published var isLoading = true
    @Published var currentCategory = NewsCategories.categories[0]
    @Published var currentPage = 1
    @Published var searchText = ""
    
    var abbreviation = "-"
    
    // MARK: - сервисы
    private let newsService = ASPUNewsService()
    private let settingsManager = SettingsManager()
    
    init() {
        observeCategory()
    }
    
    func getNews() {
        
        let abbreviation = settingsManager.getSavedCategory()
        currentCategory = NewsCategories.categories.first(where: { $0.abbreviation == abbreviation})!
        
        self.abbreviation = abbreviation
        
        if currentCategory.abbreviation != "-" {
            Task {
                let result = try await newsService.getNews(abbreviation: abbreviation)
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.newsResponse = data
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print(error)
                }
            }
        } else {
            Task {
                let result = try await newsService.getASPUNews()
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.newsResponse = data
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
    
    func getNews(abbreviation: String) {
        currentCategory = NewsCategories.categories.first(where: { $0.abbreviation == abbreviation})!
        self.abbreviation = abbreviation
        self.currentPage = 1
        self.isLoading = true
        if abbreviation != "-" {
            Task {
                let result = try await newsService.getNews(abbreviation: abbreviation)
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.newsResponse = data
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    print(error)
                }
            }
        } else {
            Task {
                let result = try await newsService.getASPUNews()
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.newsResponse = data
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
    
    func getNews(page: Int) {
        self.currentPage = page
        self.isLoading = true
        Task {
            let result = try await newsService.getNews(by: page, abbreviation: abbreviation)
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.newsResponse = data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print(error)
            }
        }
    }
    
    func pagesList()-> [Int] {
        var arr = [1]
        if newsResponse.countPages ?? 0 > 0 {
            arr = []
            for i in 1...(newsResponse.countPages ?? 0) {
                arr.append(i)
            }
        }
        return arr
    }
    
    func SearchNews()-> [Article] {
        if searchText.isEmpty {
            return newsResponse.articles ?? []
        } else {
            guard let news = newsResponse.articles else {return []}
            let filteredNews = news.filter { $0.title!.localizedCaseInsensitiveContains(searchText) }
            return filteredNews
        }
    }
    
    func observeCategory() {
        NotificationCenter.default.addObserver(forName: Notification.Name("category"), object: nil, queue: nil) { _ in
            self.getNews()
        }
    }
}
