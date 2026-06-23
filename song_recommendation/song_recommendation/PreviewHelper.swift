//
//  PreviewHelper.swift
//  song_recommendation
//
//  Created by Diego Gabriel Bautista Fondevill on 6/23/26.
//

import SwiftUI
import SwiftData

@MainActor
extension View { // Allows for any single view to have access to this
    
    
    func configurePreview() -> some View {
        let previewStore = MusicStore()
        
        return self
            .environment(previewStore)
            .modelContainer(for: Playlist.self, inMemory: true)
    }
}

