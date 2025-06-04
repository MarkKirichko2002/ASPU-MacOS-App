//
//  TimeTable + Extensions.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 01.06.2025.
//

import Foundation

extension TimeTable {
    
    func getPairsCount()-> Int {
        
        var uniqueTimes: Set<String> = Set()
        
        for pair in self.disciplines {
            
            let times = pair.time.components(separatedBy: "-")
            let startTime = times[0]
            
            uniqueTimes.insert(startTime)
        }
        
        return uniqueTimes.count
    }
}
