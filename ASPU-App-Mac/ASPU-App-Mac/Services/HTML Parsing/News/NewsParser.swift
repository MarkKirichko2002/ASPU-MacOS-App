//
//  NewsParser.swift
//  ASPU-App-Watch Watch App
//
//  Created by Марк Киричко on 10.09.2025.
//

import Foundation
import SwiftSoup

final class NewsParser {
    private let facultyHeader = "faculties/"
    private let hostSite = "https://www.agpu.net"
    private let urlForEverything = "/struktura-vuza/%@/news/news.php?PAGEN_1=%d"
    private let urlForArticle = "/struktura-vuza/%@/news/news.php?ELEMENT_ID=%d"
    private let urlAgpuNews = "https://www.agpu.net/news/"
    
    private let nonStandardCategories = ["educationaltechnopark", "PedagogicalQuantorium"]
    
    // MARK: - Get Articles by Faculty
    func getArticlesByFaculty(faculty: String, page: Int) async throws -> NewsResponse {
        if faculty == "-" {
            print("Redirecting faculty '-' to AGPU news")
            return try await getAgpuNews(page: page)
        }
        
        let facultyPath = nonStandardCategories.contains(faculty) ? faculty : facultyHeader + faculty
        let urlStr = "\(hostSite)" + String(format: urlForEverything, facultyPath, page)
        
        print("Fetching articles for faculty: \(faculty), page: \(page), URL: \(urlStr)")
        
        guard let url = URL(string: urlStr) else {
            print("Invalid URL: \(urlStr)")
            return NewsResponse(currentPage: 0, countPages: 0, articles: [])
        }
        
        let html = try await fetchHTML(from: url)
        let doc = try SwiftSoup.parse(html)
        return try parseNewsResponse(page: page, doc: doc)
    }
    
    func getArticleById(faculty: String, id: Int) async throws -> ArticleInfo {
        let url: URL
        if faculty == "-" {
            guard let validUrl = URL(string: "\(urlAgpuNews)\(id)/") else {
                throw URLError(.badURL)
            }
            url = validUrl
        } else {
            let category = nonStandardCategories.contains(faculty) ? faculty : "\(facultyHeader)\(faculty)"
            guard let validUrl = URL(string: String(format: urlForArticle, category, id)) else {
                throw URLError(.badURL)
            }
            url = validUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorArticle = ArticleInfo(id: 0, title: "", description: "", date: "", images: [])
                return errorArticle
            }
            
            let html = String(data: data, encoding: .utf8) ?? ""
            let doc = try SwiftSoup.parse(html)
            
            if let mainContent = try doc.getElementsByClass("mb-3").first() {
                let date = try mainContent.getElementsByClass("news-detail-date").first()?.text() ?? ""
                let title = try mainContent.getElementsByClass("news-detail-title").first()?.text() ?? "No title"
                
                let content = try mainContent.getElementsByClass("news-detail-content").first()
                let description = try recursiveParseText(element: content)
                
                var images: [String] = []
                if let imgElements = try? content?.getElementsByTag("img") {
                    for img in imgElements {
                        if let src = try? img.attr("src"), !src.isEmpty {
                            let fullSrc = src.starts(with: "/") ? hostSite + src : src
                            images.append(fullSrc)
                        }
                    }
                }
                
                return ArticleInfo(id: id, title: title, description: description, date: date, images: images)
            } else {
                let errorArticle = ArticleInfo(id: 0, title: "", description: "", date: "", images: [])
                return errorArticle
            }
        } catch {
            let errorArticle = ArticleInfo(id: 0, title: "", description: "", date: "", images: [])
            return errorArticle
        }
    }
    
    // MARK: - Get AGPU News
    func getAgpuNews(page: Int) async throws -> NewsResponse {
        let urlStr = "\(urlAgpuNews)?PAGEN_1=\(page)"
        print("Fetching AGPU news for page: \(page), URL: \(urlStr)")
        
        guard let url = URL(string: urlStr) else {
            print("Invalid URL: \(urlStr)")
            return NewsResponse(currentPage: 0, countPages: 0, articles: [])
        }
        
        let html = try await fetchHTML(from: url)
        let doc = try SwiftSoup.parse(html)
        return try parseNewsResponse(page: page, doc: doc)
    }
    
    // MARK: - HTML Fetch
    private func fetchHTML(from url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.setValue(
            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
            forHTTPHeaderField: "User-Agent"
        )
        request.setValue("text/html", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("HTTP error for URL: \(url), status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            throw URLError(.badServerResponse)
        }

        if let html = String(data: data, encoding: .utf8) {
            return html
        } else if let html = String(data: data, encoding: .windowsCP1251) {
            return html
        } else {
            throw URLError(.cannotDecodeRawData)
        }
    }

    
    // MARK: - Parse NewsResponse
    private func parseNewsResponse(page: Int, doc: Document) throws -> NewsResponse {
        var res: [Article] = []
        
        let articles = try doc.getElementsByTag("article")
        print("Found \(articles.count) article elements")
        
        for el in articles {
            do {
                res.append(try parsePreviewArticleElement(el: el))
            } catch {
                print("Failed to parse article element: \(error)")
            }
        }
        
        // Parse pagination
        var countPages = 1
        let links = try doc.getElementsByTag("a")
        for link in links {
            if let href = try? link.attr("href"),
               let comps = URLComponents(string: hostSite + (href.starts(with: "/") ? href : "/" + href)),
               let items = comps.queryItems,
               let pageNumStr = items.first(where: { $0.name == "PAGEN_1" })?.value,
               let pageNum = Int(pageNumStr),
               pageNum > countPages {
                countPages = pageNum
            }
        }
        print("Parsed page count: \(countPages)")
        
        if page > countPages {
            print("Requested page \(page) exceeds total pages \(countPages)")
            return NewsResponse(currentPage: page, countPages: page, articles: res)
        }
        
        return NewsResponse(currentPage: page, countPages: countPages, articles: res)
    }
    
    // MARK: - Parse Article
    private func parseArticlePage(element: Element, id: Int) throws -> ArticleInfo {
        guard let body = try element.getElementsByClass("news-detail-body").first() else {
            print("No news-detail-body found for article ID: \(id)")
            return ArticleInfo(id: id, title: "Article not found", description: "", date: "", images: [])
        }
        
        let date = try element.getElementsByClass("news-detail-date").first()?.text() ?? ""
        let title = try body.getElementsByTag("h3").first()?.text() ?? "No title"
        let description = try recursiveParseText(element: body.getElementsByClass("news-detail-content").first())
        
        var images: [String] = []
        for img in try body.getElementsByTag("img") {
            if let src = try? img.attr("src"), !src.isEmpty {
                let fullSrc = src.starts(with: "/") ? hostSite + src : src
                images.append(fullSrc)
            }
        }
        print("Parsed article ID: \(id), title: \(title), images: \(images.count)")
        
        return ArticleInfo(id: id, title: title, description: description, date: date, images: images)
    }
    
    // MARK: - Recursive Text Parser
    private func recursiveParseText(element: Element?) throws -> String {
        guard let el = element else { return "" }
        let children = el.children()
        
        let nonBrChildren = children.filter { child in
            (try? child.tagName()) != "br"
        }
        
        if nonBrChildren.isEmpty {
            return try el.text().trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var res = ""
        for child in children {
            res += try recursiveParseText(element: child) + " "
        }
        return res.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Parse Preview Article
    private func parsePreviewArticleElement(el: Element) throws -> Article {
        let link = try el.getElementsByTag("a").first()
        let href = try link?.attr("href") ?? ""
        let idStr = href.components(separatedBy: "/")
        let id = Int(idStr[2]) ?? -1
        
        let title = try el.getElementsByTag("h4").first()?.text() ?? "No title"
        let desc = try el.getElementsByAttributeValue("style", "text-align: justify;").first()?.text() ?? ""
        let img = try el.getElementsByTag("img").first()?.attr("src") ?? ""
        let previewImage = img.isEmpty ? "" : (img.starts(with: "/") ? hostSite + img : img)
        
        // Safely access second <li> element
        let date = try el.getElementsByTag("li").array().count > 1 ? try el.getElementsByTag("li").get(1).text() : ""
        
        print("Parsed preview article ID: \(id), title: \(title)")
        
        return Article(id: id, title: title, description: desc, date: date, previewImage: previewImage)
    }
}
