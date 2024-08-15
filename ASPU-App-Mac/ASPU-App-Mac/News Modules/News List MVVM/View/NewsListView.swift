//
//  NewsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewsListView: View {
    
    @ObservedObject var viewModel = NewsListViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.SearchNews().isEmpty {
                Text("Новостей нет")
                    .fontWeight(.bold)
            } else {
                List(viewModel.SearchNews()) { article in
                    ArticleCell(article: article)
                    .padding(10)
                }
            }
        }
        .navigationTitle("Новости")
        .onAppear {
            if viewModel.isLoading {
                viewModel.getNews()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                HStack {
                    // категории новостей
                    Picker("", selection: $viewModel.currentCategory) {
                        ForEach(NewsCategories.categories, id: \.self) { category in
                            Text(category.name)
                        }
                    }
                    .onChange(of: viewModel.currentCategory) { category in
                        viewModel.getNews(abbreviation: category.abbreviation)
                    }
                    
                    Picker("", selection: $viewModel.currentPage) {
                        ForEach(viewModel.pagesList(), id: \.self) { page in
                            Text("Страница: \(page)")
                        }
                    }
                    .onChange(of: viewModel.currentPage) { page in
                        viewModel.getNews(page: page)
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Введите текст...")
    }
}

#Preview {
    NewsListView()
}
