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
                    .fontWeight(.bold)
                Text("c \(week.from) по \(week.to)")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }.padding(15)
    }
}

#Preview {
    WeekCell(week: WeekModel(id: 1, from: "", to: "", dayNames: ["" : ""]))
}
