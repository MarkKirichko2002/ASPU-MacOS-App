//
//  SearchResultsListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 24.09.2024.
//

import SwiftUI

struct SearchResultsListView: View {
    
    private let service = TimeTableService()
    
    @State var text = ""
    @State var items = [SearchResultModel]()
    @EnvironmentObject var owner: TimetableOwner
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Text("Нет результатов")
                    .fontWeight(.bold)
            } else {
                List(items, id: \.searchID) { item in
                    HStack {
                        Text(item.searchContent)
                            .fontWeight(.bold)
                        Spacer()
                    }.contentShape(Rectangle())
                        .padding()
                        .onTapGesture {
                            owner.result = item
                            presentationMode.wrappedValue.dismiss()
                     }
                }
            }
        }
        .searchable(text: $text, prompt: "Введите текст...")
        .onChange(of: text) { oldValue, newValue in
            self.getResult(text: newValue)
        }
    }
    
    func getResult(text: String) {
        service.getSearchResults(searchText: text) { result in
            switch result {
            case .success(let data):
                self.items = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    SearchResultsListView()
}
