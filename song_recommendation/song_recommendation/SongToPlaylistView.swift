//
//  SongToPlaylistView.swift
//  song_recommendation
//
//  Created by cpsc on 5/18/26.
//

import SwiftUI

// Code for view when putting a song into playist
struct SongToPlaylistView: View {
    let song: SongDetail // Inputted song
    @Environment(MusicStore.self) var store // Accesses store scared across the whole app
    @Environment(\.dismiss) var dismiss // Dimisses screen once a action is finished
   
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                
                // UI for adding playlist
                VStack {
                    Text("Add to playlist")
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
                        .padding(15)
                    
                    // List out all of the playlist existing in the library
                    ForEach(store.playlists) { playlist in
                        PlaylistListCell(dismiss: dismiss, playlist: playlist, song: song, store: store)
                    }
                }
            }
        }
    }
}

// UI for listing how all of the playlist
struct PlaylistListCell : View {
    var dismiss: DismissAction
    let playlist: Playlist
    let song: SongDetail
    var store: MusicStore
    var body: some View {
        // Button that adds song to the playlist in MusicStore
        Button (action: {
            store.addSongToPlaylist(song: song, playlist: playlist)
            dismiss()
        }) {
            // Shows the playlists in the library Icon and Name
            HStack(spacing: 16) {
                ZStack {
                    Image(systemName: playlist.icon)
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
                    Text(playlist.name)
                        .font(.headline)
                        .foregroundColor(.white)
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
