//
//  PlayerViewModelTests.swift
//  station-playerTests
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import XCTest
@testable import station_player

final class PlayerViewModelTests: XCTestCase {
    
    private var viewModel: PlayerViewModel!
    private var stations: [Station]!
    private var station1: Station!
    private var station2: Station!
    
    override func setUp() {
        super.setUp()
        station1 = Station(id: "1", description: "Station 1", name: "Radio One", imgUrl: nil, streamUrl: "https://example.com/1", reliability: 80, popularity: 3.0, tags: ["pop"])
        station2 = Station(id: "2", description: "Station 2", name: "Radio Two", imgUrl: nil, streamUrl: "https://example.com/2", reliability: 85, popularity: 4.5, tags: ["rock"])
        stations = [station1, station2]
        viewModel = PlayerViewModel(stations: stations, currentStation: station1)
    }
    
    override func tearDown() {
        viewModel = nil
        stations = nil
        station1 = nil
        station2 = nil
        super.tearDown()
    }
    
    // Test initialization
    func testInitialization() {
        XCTAssertEqual(viewModel.currentStation, station1)
        XCTAssertTrue(viewModel.isPlaying == false)
        XCTAssertTrue(viewModel.isPrevAvailable == false)
        XCTAssertTrue(viewModel.isNextAvailable == true)
    }
    
    // Test setupAudioPlayer
    func testSetupAudioPlayer() {
        viewModel.setupAudioPlayer()
        
        XCTAssertNotNil(viewModel.player)
        XCTAssertTrue(viewModel.isPlaying)
    }
    
    // Test togglePlayPause
    func testTogglePlayPause() {
        viewModel.togglePlayPause()
        XCTAssertTrue(viewModel.isPlaying)
        
        viewModel.togglePlayPause()
        XCTAssertFalse(viewModel.isPlaying)
    }
    
    // Test nextTrack
    func testNextTrack() {
        viewModel.nextTrack()
        XCTAssertEqual(viewModel.currentStation, station2)
        XCTAssertTrue(viewModel.isPrevAvailable)
        XCTAssertFalse(viewModel.isNextAvailable)
    }
    
    // Test previousTrack
    func testPreviousTrack() {
        viewModel.nextTrack() // Move to next track
        viewModel.previousTrack()
        
        XCTAssertEqual(viewModel.currentStation, station1)
        XCTAssertFalse(viewModel.isPrevAvailable)
        XCTAssertTrue(viewModel.isNextAvailable)
    }
    
    // Test stopPlaying
    func testStopPlaying() {
        viewModel.setupAudioPlayer() // Ensure player is set up
        viewModel.stopPlaying()
        
        XCTAssertNil(viewModel.player)
        XCTAssertFalse(viewModel.isPlaying)
    }
    
    // Test startOnAppear
    func testStartOnAppear() {
        viewModel.startOnAppear()
        
        XCTAssertTrue(viewModel.isNextAvailable)
        XCTAssertFalse(viewModel.isPrevAvailable)
    }
}
