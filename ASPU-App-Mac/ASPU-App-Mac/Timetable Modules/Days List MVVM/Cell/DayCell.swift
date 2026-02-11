//
//  DayCell.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 13.05.2025.
//

import SwiftUI

struct DayCell: View {
    
    var day: DayModel
    
    var body: some View {
        HStack {
            Text("\(day.name): \(day.dayOfWeek) \(day.date) (\(day.info))")
                .fontWeight(.black)
            Spacer()
        }.contentShape(Rectangle())
            .padding()
    }
}

//#Preview {
//    DayCell()
//}
