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
    
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: article.previewImage ?? "")!)
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 30) {
                Text(article.title ?? "Нет заголовка")
                Text(article.date ?? "Нет даты")
            }
        }
    }
}

#Preview {
    ArticleCell(article: Article(id: 0, title: "", description: "", date: "", previewImage: ""))
}
