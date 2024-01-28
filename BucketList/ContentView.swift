//
//  ContentView.swift
//  BucketList
//
//  Created by Oleg Gavashi on 26.01.2024.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isUnlocked {
                ZStack(alignment: .bottomTrailing) {
                    MapReader { proxy in
                        Map {
                            ForEach(viewModel.locations) { location in
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 40, height: 40)
                                        .background(.white)
                                        .clipShape(.circle)
                                        .onLongPressGesture {
                                            viewModel.selectedLocation = location
                                        }
                                }
                            }
                        }
                        .mapStyle(viewModel.getMapStyle)
                        .onTapGesture { position in
                            if let coordinate = proxy.convert(position, from: .local) {
                                viewModel.addLocation(at: coordinate)
                            }
                        }
                    }
                    Button(action: viewModel.toggleShowPicker) {
                        Image(systemName: "map.fill")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding()
                    
                }
                .sheet(item: $viewModel.selectedLocation) { item in
                    EditView(location: item) { updatedPlace in
                        viewModel.updateLocation(location: updatedPlace)
                    }
                }
                .sheet(isPresented: $viewModel.showPicker) {
                    VStack {
                        Picker("Map style", selection: $viewModel.mapStyle) {
                            ForEach(MapTypes) { option in
                                withAnimation {
                                    Text(option.label).tag(option.key)
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                    }
                    .presentationDetents([.height(50)])
                }
            } else {
                Button(action: viewModel.authenticate) {
                    HStack {
                        Image(systemName: "lock.fill")
                        Text("Unlock me")
                    }
                }
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            }
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
