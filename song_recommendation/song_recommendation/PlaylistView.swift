//
//  PlaylistView.swift
//  song_recommendation
//
//  Created by cpsc on 5/16/26.
//

// Code for Playlistview
import SwiftUI

struct PlaylistView: View {
    let selectedPlaylist: Playlist // Stores selected playlist
    @State private var isPlaying: Bool = false // Checks if a song is playing
    @State private var stackPath = NavigationPath()
    @Bindable var audioManager = AudioManager.shared // Audio manager that is shared by all playlist
    
    var body: some View {
        
        // Shows icon of playlist, then its name and description. Below that shows the list of songs the playlist has
        ZStack(alignment: .bottom) {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .aspectRatio(1.0, contentMode: .fit)
                        Image(systemName: selectedPlaylist.icon)
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
                            .font(.system(size: 100))
                    }
                    .frame(height: 280)
                    .padding(.top, 20)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(selectedPlaylist.name)")
                                    .font(.title)
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
                                Text("\(selectedPlaylist.playlistDescription)")
                                    .font(.body)
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
                                    .lineLimit(3)
                            }
                            .padding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding()
                    
                    // What shows if there is no songs added yet
                    VStack(alignment: .leading, spacing: 16) {
                        if selectedPlaylist.songs.isEmpty {
                            Text("No songs added yet.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        // Shows each song in playlist
                        ForEach(selectedPlaylist.songs, id: \.track_id) { song in
                            ListCell(song: song, currentQueue: selectedPlaylist.songs)
                                .background(Color.white.opacity(0.05))
                        }
                    } .padding(.horizontal)
                }
            }
            
            // If a song is plauying then miniplayer view is shown
            if audioManager.currentTrack != nil {
                VStack {
                    MiniplayerView()
                }
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

struct ListCell: View {
    let song: any PlayableSong // Stores a song in the playlist
    let currentQueue: [any PlayableSong] // Keeps track of queue playing
    
    var body: some View {
        // Plays song through audio manager
        Button(action: {
            AudioManager.shared.playSong(song, playlistSong: currentQueue)
            print("Playing Song")
        }) {
            // Shows song icon and name of the song and artist name
            HStack(spacing: 16) {
                ZStack {
                    Image(systemName: song.icon)
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
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(song.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
    }
}

