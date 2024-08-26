//
//  StationModelTests.swift
//  station-playerTests
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import XCTest
@testable import station_player

final class StationModelTests: XCTestCase {
    
    // Test Station init
    func testStationInitializationWithAllProperties() {
        let station = Station(
            id: "1",
            description: "Top radio station",
            name: "Hits Radio",
            imgUrl: "https://example.com/image.jpg",
            streamUrl: "https://example.com/stream",
            reliability: 95,
            popularity: 4.8,
            tags: ["pop", "rock", "hits"]
        )
        
        XCTAssertEqual(station.id, "1")
        XCTAssertEqual(station.description, "Top radio station")
        XCTAssertEqual(station.name, "Hits Radio")
        XCTAssertEqual(station.imgUrl, "https://example.com/image.jpg")
        XCTAssertEqual(station.streamUrl, "https://example.com/stream")
        XCTAssertEqual(station.reliability, 95)
        XCTAssertEqual(station.popularity, 4.8)
        XCTAssertEqual(station.tags, ["pop", "rock", "hits"])
    }
    
    // Test Station init when has nil
    func testStationInitializationWithNilOptionalProperties() {
        let station = Station(
            id: "2",
            description: "Classic radio station",
            name: "Classic FM",
            imgUrl: nil,
            streamUrl: "https://example.com/classicstream",
            reliability: 90,
            popularity: nil,
            tags: ["classical", "instrumental"]
        )
        
        XCTAssertEqual(station.id, "2")
        XCTAssertEqual(station.description, "Classic radio station")
        XCTAssertEqual(station.name, "Classic FM")
        XCTAssertNil(station.imgUrl)
        XCTAssertEqual(station.streamUrl, "https://example.com/classicstream")
        XCTAssertEqual(station.reliability, 90)
        XCTAssertEqual(station.popularityValue, 0.0)
        XCTAssertEqual(station.tags, ["classical", "instrumental"])
    }
    
    // Test imageURL computed property
    func testImageURL() {
        let station = Station(
            id: "1",
            description: "Radio with an image",
            name: "Visual Radio",
            imgUrl: "https://example.com/image.jpg",
            streamUrl: "https://example.com/stream",
            reliability: 95,
            popularity: 4.5,
            tags: ["pop"]
        )
        
        XCTAssertEqual(station.imageURL, URL(string: "https://example.com/image.jpg"))
    }
    
    // Test imageURL when imgUrl is nil
    func testImageURLWhenImgUrlIsNil() {
        let station = Station(
            id: "3",
            description: "Radio without an image",
            name: "Audio Radio",
            imgUrl: nil,
            streamUrl: "https://example.com/stream",
            reliability: 88,
            popularity: 3.9,
            tags: ["news"]
        )
        
        XCTAssertNil(station.imageURL)
    }
    
    // Test trackUrl computed property
    func testTrackUrl() {
        let station = Station(
            id: "4",
            description: "Streaming station",
            name: "Stream Radio",
            imgUrl: "https://example.com/image.jpg",
            streamUrl: "https://example.com/stream",
            reliability: 92,
            popularity: 4.2,
            tags: ["jazz"]
        )
        
        XCTAssertEqual(station.trackUrl, URL(string: "https://example.com/stream"))
    }
    
    // Test popularityValue when popularity is nil
    func testPopularityValueWhenNil() {
        let station = Station(
            id: "5",
            description: "Radio with no popularity rating",
            name: "Niche Radio",
            imgUrl: "https://example.com/image.jpg",
            streamUrl: "https://example.com/stream",
            reliability: 75,
            popularity: nil,
            tags: ["indie"]
        )
        
        XCTAssertEqual(station.popularityValue, 0.0)
    }
    
    // Test Codable conformance by encoding and decoding a Station instance
    func testStationCodable() {
        let station = Station(
            id: "6",
            description: "Codable test station",
            name: "Test Radio",
            imgUrl: "https://example.com/testimage.jpg",
            streamUrl: "https://example.com/teststream",
            reliability: 85,
            popularity: 4.0,
            tags: ["test", "mock"]
        )
        
        // Encoding
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(station)
            
            // Decoding
            let decoder = JSONDecoder()
            let decodedStation = try decoder.decode(Station.self, from: data)
            
            XCTAssertEqual(decodedStation.id, station.id)
            XCTAssertEqual(decodedStation.description, station.description)
            XCTAssertEqual(decodedStation.name, station.name)
            XCTAssertEqual(decodedStation.imgUrl, station.imgUrl)
            XCTAssertEqual(decodedStation.streamUrl, station.streamUrl)
            XCTAssertEqual(decodedStation.reliability, station.reliability)
            XCTAssertEqual(decodedStation.popularity, station.popularity)
            XCTAssertEqual(decodedStation.tags, station.tags)
        } catch {
            XCTFail("Failed to encode or decode Station: \(error)")
        }
    }
}
