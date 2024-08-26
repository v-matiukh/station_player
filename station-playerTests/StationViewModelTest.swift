//
//  StationViewModelTest.swift
//  station-playerTests
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import XCTest
@testable import station_player

final class StationViewModelTest: XCTestCase {
    
    private var viewModel: StationsViewModel!
    private var mockNetworkService: MockRequestable!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockRequestable()
        viewModel = StationsViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // Test that stations are fetched and sorted by popularity correctly
    func testFetchStationsSuccess() async {
        // Given
        let stations = [
            Station(id: "1", description: "Station 1", name: "Radio One", imgUrl: nil, streamUrl: "https://example.com/1", reliability: 80, popularity: 3.0, tags: ["pop"]),
            Station(id: "2", description: "Station 2", name: "Radio Two", imgUrl: nil, streamUrl: "https://example.com/2", reliability: 85, popularity: 4.5, tags: ["rock"]),
            Station(id: "3", description: "Station 3", name: "Radio Three", imgUrl: nil, streamUrl: "https://example.com/3", reliability: 75, popularity: 2.0, tags: ["jazz"])
        ]
        
        mockNetworkService.result = .success(stations)
        
        // When
        let result = await viewModel.fetchStations()
        
        // Then
        switch result {
        case .success(let fetchedStations):
            XCTAssertEqual(fetchedStations.count, 3)
            XCTAssertEqual(fetchedStations[0].name, "Radio Two") // Highest popularity
            XCTAssertEqual(fetchedStations[1].name, "Radio One")
            XCTAssertEqual(fetchedStations[2].name, "Radio Three") // Lowest popularity
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    // Test that an error is correctly returned when the network call fails
    func testFetchStationsFailure() async {
        // Given
        mockNetworkService.result = .failure(.unknown)
        
        // When
        let result = await viewModel.fetchStations()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual(error, .unknown)
        }
    }
}
// MARK: - Mock Requestable Service

final class MockRequestable: Requestable {
    var result: Result<[Station], NetworkError>!
    
    func fetchStations() async -> Result<[Station], NetworkError> {
        return result
    }
}
