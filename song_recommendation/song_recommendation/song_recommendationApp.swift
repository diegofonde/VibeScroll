//
//  song_recommendationApp.swift
//  song_recommendation
//
//  Created by cpsc on 5/5/26.
//

import SwiftUI
import SwiftData

@main
struct song_recommendationApp: App {
    
    @State private var store = MusicStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .onAppear {
                    store.modelContext = EnvironmentValues().modelContext
                }
        }
        .modelContainer(for: Playlist.self)
    }
}
