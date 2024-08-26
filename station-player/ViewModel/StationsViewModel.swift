//
//  StationsViewModel.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import Foundation

class StationsViewModel {
    private let networkService: Requestable
    
    init(networkService: Requestable = NetworkService(baseURL: Constants.URL.baseURL.rawValue)) {
        self.networkService = networkService
    }
    
    func fetchStations() async -> Result<[Station], NetworkError> {
        let result = await networkService.fetchStations()
        if case let .success(stations) = result {
            return .success(stations.sorted(by: { $0.popularityValue > $1.popularityValue }))
        } else {
            return result
        }
    }
}
