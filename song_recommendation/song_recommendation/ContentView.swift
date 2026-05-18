//
//  ContentView.swift
//  song_recommendation
//
//  Created by cpsc on 5/5/26.
//

import SwiftUI

// Code for different tabs
struct ContentView: View {
    @State private var selectedTab = 0 // Default tab value is 0

    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView() // Tab to library view
                .tabItem {
                    Label("Library", systemImage: "music.note.house.fill")
                }
                .tag(0)
            
            SearchView() // Tab for search view
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            PresentationCard() // Tab for Presentation card
                .tabItem {
                    Label("Presentation", systemImage: "arrow.2.circlepath.circle")
                }
        }
        .tint(Color("BrandSecondary"))
        
        
        .task { // When the content view is showing, tests superbase connection. Prints online if it works and offline if it does not.
            let success = await SupabaseManager.shared.testPublicConnection()
            if success {
                print("Online")
            }
            else {
                print("Offline")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(MusicStore())
}
