//
//  EditView.swift
//  BucketList
//
//  Created by Oleg Gavashi on 27.01.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    
    init(location: Location, save: @escaping (Location) -> Void) {
        _viewModel = State(initialValue: ViewModel(location: location, save: save))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
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
                    Button("Save") {
                        viewModel.handleSave()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.getNearby()
            }
        }
    }
}

#Preview {
    EditView(location: Location.example, save: { _ in })
        .preferredColorScheme(.dark)
}
