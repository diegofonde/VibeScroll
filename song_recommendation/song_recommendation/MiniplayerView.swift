//
//  MiniplayerView.swift
//  song_recommendation
//
//  Created by cpsc on 5/17/26.
//

import SwiftUI

// Code for MiniplayerView that shows when a song is playing in a playlist
struct MiniplayerView: View {
    
    // Grabs shared audio manager
    @Bindable var audioManager = AudioManager.shared
    
    var body: some View {
        
        // Shows up if the audioManager has a current track playing
        if let currentTrack = audioManager.currentTrack {
            
            // Slider that keeps track of the time past of the song based on the total duration
            VStack(spacing: 4) {
                Slider(value: Binding(
                    get: {audioManager.currentTime},
                    set: {newValue in audioManager.seek(to: newValue)}
                ), in: 0...(audioManager.totalDuration > 0 ? audioManager.totalDuration: 30))
                .tint(
                    LinearGradient(
                    gradient: Gradient(colors: [
                        Color("BrandPrimary"),
                        Color("BrandSecondary")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                    )
                )
                .controlSize(.mini)
            }
            
            // HStack that shows the tracks icon, name and artist
            HStack(spacing: 12) {
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                    Image(systemName: currentTrack.icon)
                        .foregroundStyle(
                            LinearGradient(
                            gradient: Gradient(colors: [
                                Color("BrandPrimary"),
                                Color("BrandSecondary")
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                            )
                        )
                        .font(.title3)
                }
                .frame(width: 48, height: 48)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentTrack.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(currentTrack.artist)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Separate hstack that has buttons for puasing and skipping the song
                HStack(spacing: 4) {
                    Button(action: {
                        audioManager.pauseSong()
                    }) {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                    
                    Button(action: {
                        audioManager.skipSong()
                    }) {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.05))
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            }
        }
    }
}
