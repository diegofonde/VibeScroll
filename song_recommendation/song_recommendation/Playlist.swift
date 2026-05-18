//
//  Playlist.swift
//  song_recommendation
//
//  Created by cpsc on 5/14/26.
//

import Foundation
import SwiftUI
import SwiftData

// Structure for playlist, ensures unique ID and array to store songs
@Model
class Playlist: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var playlistDescription: String
    var icon: String
    
    // Relationship of playlist and songs
    @Relationship(deleteRule: .cascade) var songs: [LocalSong]

    // Initializer for asigning values of playlist
    init(id: UUID = UUID(), name: String, description: String, icon: String = "music.note.house", songs: [LocalSong] = []) {
        self.id = id
        self.name = name
        self.playlistDescription = description
        self.icon = icon
        self.songs = songs
    }
    
    static func == (lhs: Playlist, rhs: Playlist) -> Bool {
            lhs.id == rhs.id
        }

        // Hashable: Use the unique ID property to generate the hash value
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
