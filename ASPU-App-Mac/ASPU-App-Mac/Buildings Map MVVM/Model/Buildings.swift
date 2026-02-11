//
//  Buildings.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import MapKit

struct BuildingModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let image: [String]
    let type: BuildingType
    let audiences: [String]?
    let pin: [Double]
}

enum BuildingType {
    case all
    case building
    case hostel
    case buildingAndHostel
}

struct Buildings {
    
    static let pins = [
        BuildingModel(
            id: 1,
            name: "Главный корпус",
            image: ["главный корпус"],
            type: .building,
            audiences: [
                "1",
                "2",
                "3",
                "4",
                "4а",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12",
                "13",
                "14",
                "14а",
                "15",
                "15а",
                "16",
                "17",
                "18",
                "21",
                "22",
                "23",
                "23a",
                "23б",
                "23в"
            ],
            pin: [45.001817, 41.132393]
        ),
        BuildingModel(
            id: 2,
            name: "Корпус и Общежитие №1",
            image: ["общежитие 1"],
            type: .buildingAndHostel,
            audiences: [
                "30",
                "31",
                "32",
                "33",
                "34",
                "35",
                "36",
                "37",
                "38",
                "101",
                "102",
                "103",
                "104",
                "105",
                "106",
                "107",
                "108",
                "109",
                "110",
                "111",
                "112",
                "113",
                "114",
                "115",
                "116",
                "117",
                "118",
                "119",
                "120",
                "121"
            ],
            pin: [45.000517, 41.126859]
        ),
        BuildingModel(
            id: 3,
            name: "Корпус №2",
            image: [],
            type: .building,
            audiences: [
                "24",
                "25",
                "26",
                "27",
                "28"
            ],
            pin: [45.000415, 41.131333]
        ),
        BuildingModel(
            id: 4,
            name: "Корпус №3 (СПФ)",
            image: ["СПФ"],
            type: .building,
            audiences: [
                "40",
                "41",
                "42",
                "43",
                "44",
                "45",
                "46",
                "47",
                "48",
                "49",
                "50"
            ],
            pin: [45.002263, 41.121873]
        ),
        BuildingModel(
            id: 5,
            name: "Корпус №4 (ФТЭиД)",
            image: ["ФТЭиД"],
            type: .building,
            audiences: [
                "51",
                "52",
                "53",
                "57",
                "58а",
                "58б",
                "59",
                "60",
                "61",
                "62",
                "63",
                "64",
                "65",
                "66",
                "67",
                "68"
            ],
            pin: [45.003697, 41.122763]
        ),
        BuildingModel(
            id: 6,
            name: "Корпус №5 (ЕБД)",
            image: [],
            type: .building,
            audiences: [
                "80",
                "81",
                "82",
                "82а",
                "83",
                "84"
            ],
            pin: [45.003372, 41.121388]
        ),
        BuildingModel(
            id: 7,
            name: "Корпус №6 (ФОК)",
            image: ["ФОК"],
            type: .building,
            audiences: [
                "85",
                "85а",
                "86",
                "86a",
                "Спортзал ФОК"
            ],
            pin: [45.006374, 41.128629]
        ),
        BuildingModel(
            id: 8,
            name: "ИСТФАК",
            image: ["истфак"],
            type: .building,
            audiences: [
                "201",
                "202",
                "203",
                "204",
                "205",
                "206",
                "207",
                "208",
                "209",
                "210"
            ],
            pin: [44.989082, 41.126904]
        ),
        BuildingModel(
            id: 9,
            name: "Общежитие №2",
            image: ["общежитие 2"],
            type: .hostel,
            audiences: nil,
            pin: [44.972907, 41.149784]
        )
    ]
}
