//
//  ArticleCell.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleCell: View {
    
    var article: Article
    var url: String
    
    var body: some View {
        HStack(spacing: 15) {
            NavigationLink {
                WebView(url: url)
            } label: {
                HStack(spacing: 20) {
                WebImage(url: URL(string: article.previewImage ?? "")!)
                    .resizable()
                    .modifier(ImageShape())
                    VStack(alignment: .leading, spacing: 30) {
                        Text(article.title ?? "Нет заголовка")
                            .fontWeight(.black)
                        Text(article.date ?? "Нет даты")
                            .fontWeight(.black)
                    }
                }
            }
        }.padding(15)
    }
}

#Preview {
    ArticleCell(article: Article(id: 0, title: "", description: "", date: "", previewImage: ""), url: "")
}
