//
//  DaysListView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 13.05.2025.
//

import SwiftUI

struct DaysListView: View {
    
    @ObservedObject var viewModel: DaysListViewModel
    @EnvironmentObject var storage: TimetableStorage
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List(viewModel.days, id: \.name) { day in
            DayCell(day: day)
                .fontWeight(.black)
                .foregroundColor(viewModel.timeTableColor(day: day))
                .onTapGesture {
                    storage.viewModel.date = viewModel.getDateFromString(date: day.date)
                    presentationMode.wrappedValue.dismiss()
                }
        }.navigationTitle("Выберите день")
        .onAppear {
            viewModel.setUpData()
        }
    }
}

//#Preview {
//    DaysListView()
//}
