//
//  PairCell.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 15.08.2024.
//

import SwiftUI

struct PairCell: View {
    
    var discipline: Discipline
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center) {
                Text(discipline.time)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                Text(discipline.name)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                Text("\(discipline.teacherName), \(discipline.audienceID)")
                    .foregroundStyle(Color.black).multilineTextAlignment(.center)
                    .multilineTextAlignment(.center)
                Text("(\(discipline.groupName))")
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                Text("(\(discipline.type.title))")
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                if discipline.subgroup != 0 {
                    Text("Подгруппа: \(discipline.subgroup)")
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            Spacer()
        }
        .listRowBackground(Color(discipline.type.color))
        .listRowSeparatorTint(.black, edges: .all)
        .background(Color(discipline.type.color))
            .ignoresSafeArea()
    }
}
#Preview {
    PairCell(discipline: Discipline(id: "", time: "", name: "", groupName: "", teacherName: "", audienceID: "", subgroup: 0, type: .all))
}
