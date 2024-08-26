//
//  PlaybackView.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import SwiftUI

struct PlaybackView: View {
    @ObservedObject
    var viewModel: PlayerViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: viewModel.currentStation.imageURL) {
                $0.resizable()
            } placeholder: {
                Image(systemName: "photo.artframe")
            }
            .frame(width: 150, height: 150)
            .clipShape(.rect(cornerRadius: 10))
            VStack {
                Text(viewModel.currentStation.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)
            HStack(spacing: 50) {
                Button(action: viewModel.previousTrack) {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .opacity(viewModel.isPrevAvailable ? 1 : 0.3)
                }
                
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                }
                
                Button(action: viewModel.nextTrack) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                        .opacity(viewModel.isNextAvailable ? 1 : 0.3)
                }
            }
            .padding(.top, 40)
            VStack(alignment: .leading) {
                HStack(spacing: 50) {
                    ForEach( viewModel.currentStation.tags, id: \.self) {
                        Text("#\($0)")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                            .padding(3)
                            .background(Color.gray.opacity(0.4))
                            .clipShape(.rect(cornerRadius: 5))
                    }
                }
            }
            .padding(.top, 10)
            Spacer()
        }
        .padding(.bottom, 50)
        .onAppear(perform: viewModel.startOnAppear)
        .onDisappear(perform: viewModel.stopPlaying)
    }
}
