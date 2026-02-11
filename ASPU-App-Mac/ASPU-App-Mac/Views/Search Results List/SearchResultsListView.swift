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
    @EnvironmentObject var storage: TimetableStorage
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            if items.isEmpty {
                Text("Нет результатов")
                    .fontWeight(.black)
            } else {
                List(items, id: \.searchID) { item in
                    HStack {
                        Text(item.searchContent)
                            .fontWeight(.black)
                        Spacer()
                    }.contentShape(Rectangle())
                        .padding()
                        .onTapGesture {
                            storage.viewModel.id = item.searchContent
                            storage.viewModel.owner = item.type.rawValue.getOwner()
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
