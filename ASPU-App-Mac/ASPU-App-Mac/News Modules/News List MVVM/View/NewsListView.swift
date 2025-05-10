//
//  NewsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewsListView: View {
    
    @StateObject var viewModel: NewsListViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if (viewModel.newsResponse.articles ?? []).isEmpty {
                Text("Новостей нет")
                    .fontWeight(.bold)
            } else {
                List(viewModel.newsResponse.articles ?? [], id: \.id) { article in
                    ArticleCell(article: article, url: viewModel.makeUrlForArticle(index: article.id))
                }
            }
        }
        .navigationTitle(viewModel.currentCategory.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    Picker("Категории", selection: $viewModel.currentCategory) {
                        ForEach(NewsCategories.categories, id: \.self) { category in
                            Text(category.name)
                        }
                        .onChange(of: viewModel.currentCategory) { oldValue, newValue in
                            viewModel.getNews(abbreviation: newValue.abbreviation)
                        }
                    }
                    Picker("Страницы", selection: $viewModel.currentPage) {
                        ForEach(viewModel.pagesList(), id: \.self) { page in
                            Text("Страница: \(page)")
                        }
                        .onChange(of: viewModel.currentPage) { oldValue, newValue in
                            viewModel.getNews(page: newValue)
                        }
                    }
                    
                    Picker("Фильтрация", selection: $viewModel.currentType) {
                        ForEach(viewModel.types, id: \.self) { type in
                            Text(type.rawValue)
                        }
                        .onChange(of: viewModel.currentType) { oldValue, newValue in
                            viewModel.filter(type: newValue)
                        }
                    }
                } label: {
                    Image("sections")
                }
            }
        }
        .onAppear {
            if viewModel.isLoading {
                viewModel.getNews()
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Введите текст...")
    }
}

//#Preview {
//    NewsListView()
//}
