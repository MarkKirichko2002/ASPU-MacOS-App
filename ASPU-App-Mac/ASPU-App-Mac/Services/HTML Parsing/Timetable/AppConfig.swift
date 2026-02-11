//
//  AppConfig.swift
//  ASPU-App-Watch Watch App
//
//  Created by Марк Киричко on 10.09.2025.
//

import Foundation

struct WeekIdMapping: Codable {
    let id: Int64
    let range: String

    private enum CodingKeys: String, CodingKey {
        case id = "id_mapping"
        case range
    }
}

final class AppConfig {
    static func getWeekIdMappings() -> [WeekIdMapping] {
        return [
            WeekIdMapping(id: 736, range: "31.08.2015-17.07.2016"),
            WeekIdMapping(id: 1476, range: "29.08.2016-16.07.2017"),
            WeekIdMapping(id: 1786, range: "28.08.2017-22.07.2018"),
            WeekIdMapping(id: 2077, range: "27.08.2018-21.07.2019"),
            WeekIdMapping(id: 2357, range: "02.09.2019-02.08.2020"),
            WeekIdMapping(id: 2613, range: "31.08.2020-08.08.2021"),
            WeekIdMapping(id: 2918, range: "30.08.2021-21.08.2022"),
            WeekIdMapping(id: 3100, range: "29.08.2022-13.08.2023"),
            WeekIdMapping(id: 3655, range: "28.08.2023-11.08.2024"),
            WeekIdMapping(id: 3922, range: "02.09.2024-20.07.2025"),
            WeekIdMapping(id: 14373, range: "01.09.2025-05.07.2026")
        ]
    }
}
