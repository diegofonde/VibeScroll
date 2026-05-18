//
//  LibraryView.swift
//  song_recommendation
//
//  Created by cpsc on 5/18/26.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @Environment(MusicStore.self) var store // Gets shared store
    @Query var savedPlaylists: [Playlist] // All of the locally saved playlist
    @Environment(\.modelContext) private var modelContext // Helps query for local data

    // Pre determined columns for how the library will look
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack { // Navigation stack that will help avigate through all of the playlist
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                ScrollView {
                    VStack (alignment: .leading, spacing: 10){
                        HStack {
                            Text("Your Library")
                                .font(.system(.title, design:.rounded))
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
                            
                            Spacer()
                            
                            // Plus button for adding a new playlist view
                            NavigationLink(destination: AddPlaylistView()) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
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
                            
                        }
                        
                        .padding()
                        
                        // For showing all of the playlist in 2 columnns
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(store.playlists) { playlist in
                                // Navigation link that shows the view of the playlist. Button is a square that shows the icon and name of the playlist
                                NavigationLink(destination: PlaylistView(selectedPlaylist: playlist)) {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.white.opacity(0.05))
                                                .aspectRatio(1.0, contentMode: .fit)
                                            Image(systemName: playlist.icon.isEmpty ? "music.note.list" : playlist.icon)
                                                .font(.system(size: 32))
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
                                        VStack {
                                            Text(playlist.name)
                                                .font(.system(.body, design: .rounded))
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                if store.modelContext == nil {
                    store.modelContext = modelContext
                }
            }
        }
    }
}
