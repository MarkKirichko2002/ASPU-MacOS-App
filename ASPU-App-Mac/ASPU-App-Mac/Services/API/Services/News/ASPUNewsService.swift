//
//  ASPUNewsService.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import Alamofire
import Foundation

final class ASPUNewsService {

    // получить новости по факультету
    func getNews(abbreviation: String) async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getArticlesByFaculty(faculty: abbreviation, page: 1)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости АГПУ
    func getASPUNews() async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getAgpuNews(page: 1)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить новости по странице и факультету
    func getNews(by page: Int, abbreviation: String) async throws -> Result<NewsResponse, Error> {
        let parser = NewsParser()
        do {
            let response = try await parser.getArticlesByFaculty(faculty: abbreviation, page: page)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
    
    // получить информацию о конкретной статье
    func getArticleInfo(abbreviation: String, id: Int) async throws -> Result<ArticleInfo, Error> {
        let parser = NewsParser()
        do {
            let article: ArticleInfo
            if abbreviation == "-" {
                article = try await parser.getArticleById(faculty: "-", id: id)
            } else {
                article = try await parser.getArticleById(faculty: abbreviation, id: id)
            }
            return .success(article)
        } catch {
            return .failure(error)
        }
    }
    
    // получить URL для конкретной статьи
    func urlForCurrentArticle(abbreviation: String, index: Int)-> String {
        
        var newsURL = ""
        
        if abbreviation == "-"  {
            newsURL = "https://agpu.net/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "educationaltechnopark" {
            newsURL = "https://www.agpu.net/struktura-vuza/educationaltechnopark/news/news.php?ELEMENT_ID=\(index)"
        } else if abbreviation == "PedagogicalQuantorium"  {
            newsURL = "https://www.agpu.net/struktura-vuza/PedagogicalQuantorium/news/news.php?ELEMENT_ID=\(index)"
        } else {
            newsURL = "https://agpu.net/struktura-vuza/faculties/\(abbreviation)/news/news.php?ELEMENT_ID=\(index)"
        }
        
        return newsURL
    }
}
