//
//  ASPUNewsService.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Alamofire
import Foundation

final class ASPUNewsService {

    // получить новости
    func getNews(abbreviation: String) async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: "https://\(HostName.host)/api/news/\(abbreviation)")!
        let request = URLRequest(url: url)
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости АГПУ
    func getASPUNews() async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: "https://\(HostName.host)/api/news")!
        let request = URLRequest(url: url)
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    func getNews(by page: Int, abbreviation: String) async throws -> Result<NewsResponse, Error> {
        
        let url = URL(string: urlForPagination(abbreviation: abbreviation, page: page))!
        let request = URLRequest(url: url)
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(NewsResponse.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
    
    // получить URL для конкретной статьи
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String {
        
        var newsURL = ""
        
        if abbreviation == "-"  {
            newsURL = "http://agpu.net/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "educationaltechnopark" {
            newsURL = "http://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "PedagogicalQuantorium"  {
            newsURL = "http://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?ELEMENT_ID=\(index)"
        } else {
            newsURL = "http://agpu.net/struktura-vuza/faculties/\(abbreviation)/news/news.php?ELEMENT_ID=\(index)"
        }
        
        return newsURL
    }
    
    // получить URL для пагинации
    func urlForPagination(abbreviation: String, page: Int)-> String {
        var url = ""
        if abbreviation != "-" {
            url = "https://\(HostName.host)/api/news/\(abbreviation)?page=\(page)"
            print(url)
            return url
        } else {
            url = "https://\(HostName.host)/api/news?page=\(page)"
            print(url)
            return url
        }
    }
    
    func getArticleInfo(abbreviation: String, id: Int) async throws -> Result<ArticleInfo, Error> {
        
        var url = ""
        
        if abbreviation != "-" {
            url = "https://\(HostName.host)/api/news/\(abbreviation)/\(id)"
        } else {
            url = "https://\(HostName.host)/api/news/agpu/\(id)"
        }
        
        let request = URLRequest(url: URL(string: url)!)
        
        let data = try await URLSession.shared.data(for: request)
        
        do {
            let news = try JSONDecoder().decode(ArticleInfo.self, from: data.0)
            return .success(news)
        } catch {
            return .failure(error)
        }
    }
}

