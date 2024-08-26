//
//  ContentView.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State
    var stations: [Station] = []
    
    @State
    var errorMessage: String?
    
    private let viewModel = StationsViewModel()
    
    var body: some View {
        NavigationView {
            List(stations) { item in
                
                    StationListItemView(data: .init(name: item.name,
                                                    imageURL: item.imageURL,
                                                    description: item.description,
                                                    popularity: "\(item.popularityValue)"))
                    .lineSpacing(5)
                    .listRowSeparator(.hidden)
                    .overlay {
                        NavigationLink {
                            PlaybackView(viewModel: .init(stations: stations, currentStation: item))
                        } label: {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                let result = await viewModel.fetchStations()
                switch result {
                case .success(let stations):
                    self.stations = stations
                case .failure(let error):
                    errorMessage = error.errorDescription
                }
            }
        }
        .alert(isPresented: .constant(errorMessage != nil)) {
            return Alert(
                title: Text("Error"),
                message: Text(errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Stations")
    }
}

#Preview {
    ContentView()
}
