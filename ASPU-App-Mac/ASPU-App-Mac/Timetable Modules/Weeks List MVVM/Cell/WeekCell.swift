//
//  WeekCell.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.09.2024.
//

import SwiftUI

struct WeekCell: View {
    
    var week: WeekModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 15) {
                Text("\(week.id)")
                    .multilineTextAlignment(.center)
                    .fontWeight(.black)
                Text("c \(week.from) по \(week.to)")
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }.contentShape(Rectangle())
        .padding(15)
    }
}

#Preview {
    WeekCell(week: WeekModel(id: 1, from: "", to: "", dayNames: ["" : ""]))
}
