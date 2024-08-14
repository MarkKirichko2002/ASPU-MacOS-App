//
//  BuildingsMapViewModel.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import MapKit
import SwiftUI

final class BuildingsMapViewModel: ObservableObject {
    
    @Published var selected: Int?
    @Published var currentLocation = Buildings.pins[0]
    @Published var camera: MapCameraPosition = .automatic
    @Published var buildings = Buildings.pins
    @Published var isPresented = false
    @Published var isPresentedOptions = false
    
    // MARK: - сервисы
    private let locationManager = LocationManager()
    
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
                        if !self.buildings.contains(where: { $0.name == "Вы" }) {
                            self.buildings.append(BuildingModel(id: 10, name: "Вы", image: [], type: .all, audiences: nil, pin: [location.coordinate.latitude, location.coordinate.longitude]))
                            self.currentLocation = self.buildings.last!
                        }
                    }
                }
            } else {
                fatalError()
            }
        }
    }
    
    func selectLocation(building: BuildingModel) {
        DispatchQueue.main.async {
            self.currentLocation = building
            self.camera = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: building.pin[0], longitude: building.pin[1]), latitudinalMeters: 200, longitudinalMeters: 200))
        }
    }
}
