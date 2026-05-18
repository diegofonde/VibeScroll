//
//  AddSongView.swift
//  song_recommendation
//
//  Created by cpsc on 5/14/26.
//

import SwiftUI
import SwiftData // 1. ADDED: Required so this view can talk to SwiftData

struct AddPlaylistView: View {
    @Environment(MusicStore.self) var store
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var newPlaylistName: String = ""
    @State private var newPlaylistDescription: String = ""
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                Text("Making Playlist")
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
                Image(systemName: "music.note.list")
                    .font(.system(size: 170))
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
                    .padding(35)
                
                VStack {
                    Text("Playlist Name: ")
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
                    TextField("", text: $newPlaylistName, prompt: Text("Enter playlist name...")
                        .foregroundColor(.gray))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                .padding()
                
                VStack {
                    Text("Playlist Description: ")
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
                    TextField("", text: $newPlaylistDescription, prompt: Text("Enter playlist description...")
                        .foregroundColor(.gray))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                }
                
                Button(
                    action: {
                        let playlistToSave = Playlist(name: newPlaylistName, description: newPlaylistDescription, songs: [])
                        
                        modelContext.insert(playlistToSave)
                        
                        try? modelContext.save()
                    
                        store.playlists.append(playlistToSave)
                        
                        dismiss()
                    }) {
                        Text("Create")
                            .font(.system(.title, design:.rounded))
                            .frame(width: 110, height: 50)
                            .clipShape(Capsule())
                            .foregroundStyle(.black)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color("BrandPrimary"),
                                        Color("BrandSecondary")
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                    .padding(15)
                    .disabled(newPlaylistName.isEmpty)
                
            }
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    AddPlaylistView()
        .environment(MusicStore())
        .modelContainer(for: Playlist.self, inMemory: true)
}
