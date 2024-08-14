//
//  BuildingsMapView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI
import MapKit

struct BuildingsMapView: View {
    
    @ObservedObject var viewModel = BuildingsMapViewModel()
    
    var body: some View {
        Map(position: $viewModel.camera, selection: $viewModel.selected) {
            ForEach(viewModel.buildings) { building in
                let index = viewModel.indexOfBuilding(building: building)
                Marker(building.name, coordinate: CLLocationCoordinate2D(latitude: building.pin[0], longitude: building.pin[1])).tag(index)
            }
        }
        .navigationTitle("Карты")
        .onAppear {
            viewModel.getLocation()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                HStack {
                    Picker("", selection: $viewModel.currentLocation) {
                        ForEach(viewModel.buildings, id: \.self) { location in
                            Text(location.name)
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.currentLocation) { location in
            viewModel.selectLocation(building: location)
        }
    }
}

#Preview {
    BuildingsMapView()
}
