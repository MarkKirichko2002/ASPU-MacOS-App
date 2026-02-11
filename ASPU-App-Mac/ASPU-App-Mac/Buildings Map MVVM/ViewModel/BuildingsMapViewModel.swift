//
//  BuildingsMapViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import MapKit
import SwiftUI

enum MapStyles: String, Codable, CaseIterable, Hashable {
    case standard
    case image
    case hybrid
    
    var title: String {
        switch self {
        case .standard:
            return "Стандартный"
        case .image:
            return "Спутниковый"
        case .hybrid:
            return "Гибридный"
        }
    }
    
    func style() -> MapStyle {
        switch self {
        case .standard:
            return .standard
        case .image:
            return .imagery
        case .hybrid:
            return .hybrid
        }
    }
}

final class BuildingsMapViewModel: ObservableObject {
    
    @Published var selected: Int?
    @Published var currentLocation = Buildings.pins[0]
    @Published var mapStyles = MapStyles.allCases
    @AppStorage("map style") var currentMapStyle = MapStyles.standard
    @Published var camera: MapCameraPosition = .automatic
    @Published var buildings = Buildings.pins
    @Published var isLoading = true
    @Published var navigationTitle = "Поиск..."
    
    // MARK: - сервисы
    private let locationManager = LocationManager()
    
    init() {
        observeMapStyleChanges()
    }
    
    func indexOfBuilding(building: BuildingModel)-> Int {
        return buildings.firstIndex { $0.name == building.name} ?? 0
    }
    
    func getLocation() {
        locationManager.checkLocationAuthorization { isAuth in
            if isAuth {
                self.locationManager.getLocations()
                self.locationManager.registerLocationHandler { location in
                    DispatchQueue.main.async {
                        self.camera = .region(MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200))
                        self.isLoading = false
                        if !self.buildings.contains(where: { $0.name == "Вы" }) {
                            self.buildings = []
                            self.buildings.append(BuildingModel(id: 0, name: "Вы", image: [], type: .all, audiences: nil, pin: [location.coordinate.latitude, location.coordinate.longitude]))
                            for i in Buildings.pins {
                                self.buildings.append(i)
                            }
                            self.currentLocation = self.buildings.first!
                        }
                    }
                }
            }
        }
    }
    
    func selectLocation(building: BuildingModel) {
        DispatchQueue.main.async {
            self.currentLocation = building
            self.camera = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: building.pin[0], longitude: building.pin[1]), latitudinalMeters: 200, longitudinalMeters: 200))
        }
    }
    
    func updateNavigationTitle() {
        if currentLocation.name == "Вы" {
            DispatchQueue.main.async {
                self.navigationTitle = "Текущая локация"
            }
        } else {
            if let index = buildings.firstIndex(of: currentLocation) {
                DispatchQueue.main.async {
                    self.navigationTitle = "Корпус \(index)/\(self.buildings.count - 1)"
                }
            }
        }
    }
    
    func observeMapStyleChanges() {
        NotificationCenter.default.addObserver(forName: Notification.Name("map style changed"), object: nil, queue: .main) { notification in
            if let style = notification.object as? MapStyles {
                self.currentMapStyle = style
            }
        }
    }
}
