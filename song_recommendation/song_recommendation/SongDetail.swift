//
//  SongDetail.swift
//  song_recommendation
//
//  Created by cpsc on 5/14/26.
//

import SwiftUI
import SwiftData

// Song Details for retrieving song information

// Important details like track_id, name, artist, itunes_preview and icon
protocol PlayableSong {
    var track_id: String { get }
    var name: String { get }
    var artist: String { get }
    var itunes_preview: String? { get }
    var icon: String { get }
}

// Allows the data to be saved in a database, or their data to be encoded
struct SongDetail: Codable, Identifiable, Hashable, PlayableSong{
    var id: String { track_id }
    var icon: String {"waveform"}
    let track_id: String
    let name: String
    let artist: String
    let itunes_preview: String?
    
    // Initializer that asigns values to the variables
    init(track_id: String, name: String, artist: String, itunes_preview: String? = nil) {
            self.track_id = track_id
            self.name = name
            self.artist = artist
            self.itunes_preview = itunes_preview
        }
    
    enum CodingKeys: String, CodingKey {
        case track_id, name, artist, itunes_preview
    }
}

// Code needed for DataSwift Storage
@Model
class LocalSong: PlayableSong {
    @Attribute(.unique) var track_id: String
    var name: String
    var artist: String
    var itunes_preview: String?
    var icon: String = "waveform"
    var playlist: Playlist?

    init(track_id: String, name: String, artist: String, itunes_preview: String? = nil) {
        self.track_id = track_id
        self.name = name
        self.artist = artist
        self.itunes_preview = itunes_preview
    }
    
    convenience init(from networkSong: SongDetail) {
        self.init(
            track_id: networkSong.track_id,
            name: networkSong.name,
            artist: networkSong.artist,
            itunes_preview: networkSong.itunes_preview
        )
    }
}
