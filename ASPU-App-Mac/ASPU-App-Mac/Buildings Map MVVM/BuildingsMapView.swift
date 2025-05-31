//
//  BuildingsMapView.swift
//  ASPU-App-Mac
//
//  Created by Марк Киричко on 14.08.2024.
//

import SwiftUI
import MapKit

struct BuildingsMapView: View {
    
    @StateObject var viewModel: BuildingsMapViewModel
    
    var body: some View {
        Map(position: $viewModel.camera, selection: $viewModel.selected) {
            ForEach(viewModel.buildings) { building in
                let index = viewModel.indexOfBuilding(building: building)
                Marker(building.name, coordinate: CLLocationCoordinate2D(latitude: building.pin[0], longitude: building.pin[1])).tag(index)
            }
        }
        .navigationTitle("")
        .onAppear {
            if viewModel.isLoading {
                viewModel.getLocation()
            }
        }
        .mapStyle(viewModel.currentMapStyle.style())
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(alignment: .center) {
                    Image("map")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                    Text(viewModel.navigationTitle)
                        .fontWeight(.black)
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Menu {
                    Picker("Локации", selection: $viewModel.currentLocation) {
                        ForEach(viewModel.buildings, id: \.self) { location in
                            Text(location.name)
                        }
                    }
                    Picker("Стиль карты", selection: $viewModel.currentMapStyle) {
                        ForEach(viewModel.mapStyles, id: \.self) { style in
                            Text(style.title)
                        }
                    }
                } label: {
                    Image("sections")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(Color(.labelColor))
                }
            }
        }
        .onChange(of: viewModel.currentLocation) { location in
            viewModel.updateNavigationTitle()
            viewModel.selectLocation(building: location)
        }
        .onChange(of: viewModel.selected) { value in
            guard let index = value else {return}
            if index != 9 {
                viewModel.currentLocation = viewModel.buildings[index]
                if let url = URL(string: "http://maps.apple.com/?q=\(viewModel.currentLocation.pin[0]),\(viewModel.currentLocation.pin[1])") {
                        NSWorkspace.shared.open(url)
                }
            }
        }
    }
}

//#Preview {
//    BuildingsMapView()
//}
