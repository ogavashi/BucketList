//
//  ContentView.ViewModel.swift
//  BucketList
//
//  Created by Oleg Gavashi on 28.01.2024.
//

import Foundation
import LocalAuthentication
import MapKit
import _MapKit_SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedLocation: Location?
        let savePath = URL.documentsDirectory.appending(path: "SavedLocations")
        var isUnlocked = true
        var mapStyle: String = "standart"
        var showPicker: Bool = false
        var alertMessage: String = "Error"
        var showAlert = false
        
        var getMapStyle: MapStyle {
            switch mapStyle {
            case "hybrid":
                MapStyle.hybrid
            case "satellite":
                MapStyle.imagery
            default:
                MapStyle.standard
            }
        }
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        func toggleShowPicker() {
            showPicker.toggle()
        }
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Could not save data")
            }
        }
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longtitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        func updateLocation(location: Location) {
            guard let selectedLocation else { return }
            
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.alertMessage = "Could not verify your biometric"
                        self.showAlert = true
                    }
                }
            } else {
                print("No biometrics")
                self.isUnlocked = true
            }
        }
    }
}
