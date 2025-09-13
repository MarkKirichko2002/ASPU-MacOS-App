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
                    .fontWeight(.black)
            } else {
                List(viewModel.newsResponse.articles ?? [], id: \.id) { article in
                    ArticleCell(article: article, url: viewModel.makeUrlForArticle(index: article.id))
                }
            }
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    viewModel.refreshNews()
                }) {
                    Image("refresh icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 23, height: 23)
                        .foregroundStyle(Color.primary)
                }
            }
            
            ToolbarItem(placement: .principal) {
                HStack(alignment: .center) {
                    Image(viewModel.currentCategory.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 42, height: 42)
                    Text(viewModel.makeNavigationTitle())
                        .fontWeight(.black)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    Button {
                        viewModel.isDatePresented.toggle()
                    } label: {
                        Text("Поиск")
                    }
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
        .sheet(isPresented: $viewModel.isDatePresented) {
            VStack(spacing: 40) {
                Text("Выберите дату")
                    .fontWeight(.black)
                DatePicker(selection: $viewModel.date) {
                    Text("")
                }
                Button(action: {
                    viewModel.isDatePresented = false
                    viewModel.isDateSelected.toggle()
                }) {
                    Text("Выбрать")
                }
            }
            .frame(width: 400, height: 400, alignment: .center)
        }
        .onChange(of: viewModel.isDateSelected) {
            viewModel.searchNews()
        }
        .onAppear {
            if viewModel.isLoading {
                viewModel.getNews()
            }
        }
    }
}

//#Preview {
//    NewsListView()
//}
