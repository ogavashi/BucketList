//
//  ContentView.swift
//  BucketList
//
//  Created by Oleg Gavashi on 26.01.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var locations = [Location]()
    @State private var selectedLocation: Location?
    
    var body: some View {
        MapReader { proxy in
            Map {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 40)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture {
                                selectedLocation = location
                            }
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), name: "", description: "", latitude: coordinate.latitude, longtitude: coordinate.longitude)
                    
                    locations.append(newLocation)
                }
            }
        }
        .sheet(item: $selectedLocation) { item in
            EditView(location: item) { updatedPlace in
                if let index = locations.firstIndex(of: item) {
                    locations[index] = updatedPlace
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
