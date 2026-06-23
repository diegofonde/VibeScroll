//
//  MusicStore.swift
//  song_recommendation
//
//  Created by cpsc on 5/14/26.
//

// Stores all the important information

import SwiftUI
import SwiftData

@Observable class MusicStore: Identifiable {
    
    var songs: [SongDetail] // Stores all songs
    var playlists: [Playlist] // Stores all playlist
    var modelContext: ModelContext? // Acces to SwiftData
    
    // Initializer for the class
    @MainActor
    init (songs: [SongDetail] = [], playlists: [Playlist] = [], modelContext: ModelContext? = nil) {
        self.songs = songs
        self.playlists = playlists
        
        // Code for grabbing locally stored data
        if let providedContext = modelContext { // if statement if there is already existing data, the app will use that existing data
            self.modelContext = providedContext
            let descriptor = FetchDescriptor<Playlist>(sortBy: [SortDescriptor(\.name)])
            self.playlists = (try? providedContext.fetch(descriptor)) ?? []
        } else { // Else new instance of SwiftData will be created to store items locally
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            if let container = try? ModelContainer(for: Playlist.self, configurations: config) {
                        let context = container.mainContext
                        self.modelContext = context
                        
                        // Instantly grab whatever is stored locally through SwiftData
                        let descriptor = FetchDescriptor<Playlist>(sortBy: [SortDescriptor(\.name)])
                        self.playlists = (try? context.fetch(descriptor)) ?? []
                    }
        }
    }
    
    // Function to create playlist and also store it locally
    func createPlaylist(name: String, description: String){
        let newPlayList = Playlist(name: name, description: description, songs: [])
        self.playlists.append(newPlayList)
        modelContext?.insert(newPlayList)
    }
    
    // Function that creates new playlist and stores it locally
    func addSongToPlaylist(song: SongDetail, playlist: Playlist){
        if let index = self.playlists.firstIndex(of: playlist){
            let localSong = LocalSong(
                            track_id: song.track_id,
                            name: song.name,
                            artist: song.artist,
                            itunes_preview: song.itunes_preview
                        )
            self.playlists[index].songs.append(localSong)
            try? modelContext?.save()
        }
    }
}
