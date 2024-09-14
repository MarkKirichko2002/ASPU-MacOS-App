//
//  PairInfoView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.09.2024.
//

import SwiftUI

struct PairInfoView: View {
    
    @ObservedObject var viewModel: PairInfoViewModel
    
    var body: some View {
        List(viewModel.pairInfo, id: \.self) { item in
            Text(item)
                .fontWeight(.bold)
        }
        .navigationTitle("Информация")
        .onAppear {
            viewModel.setUpData()
        }.onDisappear {
            viewModel.stopTimer()
        }
    }
}

#Preview {
    PairInfoView(viewModel: PairInfoViewModel(pair: Discipline(id: "", time: "", name: "", groupName: "", teacherName: "", audienceID: "", subgroup: 0, type: .all), date: ""))
}
