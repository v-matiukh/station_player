//
//  PlayerViewModel.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import Foundation
import AVFoundation

class PlayerViewModel: ObservableObject {
    private let stations: [Station]
    
    @Published
    var currentStation: Station {
        didSet {
            setupAudioPlayer()
        }
    }
    
    init(stations: [Station], currentStation: Station, isPlaying: Bool = false, player: AVPlayer? = nil) {
        self.stations = stations
        self.currentStation = currentStation
        self.isPlaying = isPlaying
        self.player = player
        updateAvailability()
    }
    
    @Published
    var isPlaying = false
    @Published
    var isPrevAvailable = true
    @Published
    var isNextAvailable = true
    
    var player: AVPlayer?
    
    
    func setupAudioPlayer() {
        guard let url = currentStation.trackUrl else {
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
    }
    
    func startOnAppear() {
        setupAudioPlayer()
        updateAvailability()
    }
    
    private func updateAvailability(_ index: Int? = nil) {
        if let index {
            isNextAvailable = index < stations.count - 1
            isPrevAvailable = index > 0
        } else {
            guard let currentIndex = stations.firstIndex(where: { $0.id == currentStation.id }), currentIndex < stations.count else {
                return
            }
            isNextAvailable = currentIndex < stations.count - 1
            isPrevAvailable = currentIndex > 0
        }
    }
    
    func stopPlaying() {
        player?.pause()
        isPlaying.toggle()
        player = nil
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func nextTrack() {
        guard let currentIndex = stations.firstIndex(where: { $0.id == currentStation.id }), currentIndex < stations.count else {
            return
        }
        let newIndex = currentIndex + 1
        currentStation = stations[newIndex]
        updateAvailability(newIndex)
    }
    
    func previousTrack() {
        guard let currentIndex = stations.firstIndex(where: { $0.id == currentStation.id }), currentIndex > 0 else {
            return
        }
        let newIndex = currentIndex - 1
        currentStation = stations[newIndex]
        updateAvailability(newIndex)
    }
}
