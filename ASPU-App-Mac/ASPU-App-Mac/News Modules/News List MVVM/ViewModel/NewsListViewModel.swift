//
//  NewsListViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Foundation

enum FilterType: String, CaseIterable {
    case all = "Все"
    case today = "Сегодня"
    case yesterday = "Вчера"
}

final class NewsListViewModel: ObservableObject {
    
    @Published var newsResponse = NewsResponse(currentPage: 0, countPages: 0, articles: [])
    @Published var isPresented = false
    @Published var isLoading = true
    @Published var currentCategory = NewsCategories.categories[0]
    @Published var currentPage = 1
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                newsResponse.articles = allNews
            } else {
                newsResponse.articles = SearchNews()
            }
            return newsResponse.articles = SearchNews()
        }
    }
    @Published var currentType = FilterType.all
    
    var allNews = [Article]()
    var types = FilterType.allCases
    
    var abbreviation = "-"
    
    // MARK: - сервисы
    private let newsService = ASPUNewsService()
    private let dateManager = DateManager()
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
                        self.allNews = data.articles ?? []
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
                        self.allNews = data.articles ?? []
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
                        self.allNews = data.articles ?? []
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
                        self.allNews = data.articles ?? []
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
                    self.allNews = data.articles ?? []
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
            allNews = newsResponse.articles ?? []
            return allNews
        } else {
            let filteredNews = allNews.filter { $0.title!.lowercased().contains(searchText) }
            DispatchQueue.main.async {
                self.currentType = .all
            }
            return filteredNews
        }
    }
    
    func makeUrlForArticle(index: Int)-> String {
        return newsService.urlForCurrentArticle(abbreviation: abbreviation, index: index)
    }
    
    func filterNews(type: FilterType)-> [Article] {
        switch type {
        case .all:
            return allNews
        case .today:
            return allNews.filter({ $0.date == dateManager.getCurrentDate()})
        case .yesterday:
            let today = dateManager.getCurrentDate()
            let yesterday = dateManager.previousDay(date: today)
            return allNews.filter({ $0.date == yesterday})
        }
    }
    
    func filter(type: FilterType) {
        print(type)
        DispatchQueue.main.async {
            self.currentType = type
            self.newsResponse.articles = self.filterNews(type: type)
        }
    }
    
    func observeCategory() {
        NotificationCenter.default.addObserver(forName: Notification.Name("category"), object: nil, queue: nil) { _ in
            self.getNews()
        }
    }
}
