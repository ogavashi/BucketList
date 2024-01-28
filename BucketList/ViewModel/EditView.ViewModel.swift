//
//  EditView.ViewModel.swift
//  BucketList
//
//  Created by Oleg Gavashi on 28.01.2024.
//

import Foundation

extension EditView {
    @Observable
    class ViewModel {
        var location: Location
        var name: String
        var description: String
        var loadingState = LoadingState.loading
        var save: (Location) -> Void
        var pages = [Page]()
        
        init(location: Location, save: @escaping (Location) -> Void) {
            self.location = location
            self.name = location.name
            self.description = location.description
            self.save = save
        }
        
        func handleSave() {
            var updatedLocation = location
            updatedLocation.id = UUID()
            updatedLocation.name = name
            updatedLocation.description = description
            save(updatedLocation)
        }
        
        func getNearby() async {
            do {
                pages = try await fetchNearby(location) ?? []
                loadingState = .loaded
            } catch {
                print(error)
                loadingState = .failed
            }
        }
    }
}
