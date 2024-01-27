//
//  EditView.swift
//  BucketList
//
//  Created by Oleg Gavashi on 27.01.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var save: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    init(location: Location, save: @escaping (Location) -> Void) {
        self.location = location
        self.save = save
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    func handleSave() {
        var updatedLocation = location
        updatedLocation.id = UUID()
        updatedLocation.name = name
        updatedLocation.description = description
        
        save(updatedLocation)
        dismiss()
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
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            VStack(alignment: .leading) {
                                Text(page.title)
                                    .font(.headline)
                                
                                Text(page.description)
                                    .italic()
                                    .font(.subheadline)
                            }
                        }
                    case .failed:
                        Text("Something went wrong. Try again later.")
                    }
                }
            }
            .navigationTitle("Edit location")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: handleSave)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                await getNearby()
            }
        }
    }
}

#Preview {
    EditView(location: Location.example, save: { _ in })
        .preferredColorScheme(.dark)
}
