//
//  SearchView.swift
//  song_recommendation
//
//  Created by cpsc on 5/18/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    @State private var searchResults: [SongDetail] = []
    @State private var isSearching: Bool = false
    @State private var selectedSong: SongDetail? = nil
    @Environment(MusicStore.self) var store
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                
                if isSearching {
                    ProgressView("Searching for tracks...")
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
                } else if !searchText.isEmpty {
                    List(searchResults, id: \.track_id) { song in
                        ResultCell(song: song) {
                            selectedSong = song
                        }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                    .listStyle(.plain)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "music.note.magnifyingglass")
                            .font(.system(size: 64))
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
                        Text("Search for songs")
                            .font(.headline)
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
                        Text("Search by song title or artist name")
                            .font(.subheadline)
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
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, prompt: "Songs, Artists")
        .onSubmit(of: .search) {
            searchSong(query: searchText)
        }
        
        .sheet(item: $selectedSong) { song in
            SongToPlaylistView(song: song)
        }
    }
    
    private func searchSong(query: String) {
        let trimmed_query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmed_query.isEmpty else {
            searchResults = []
            return }
        
        Task {
            isSearching = true
            
            do {
                let discoveredSongs = try await SupabaseManager.shared.searchSongs(query: trimmed_query)
                self.searchResults = discoveredSongs
            } catch {
                print("Database search failed: \(error.localizedDescription)")
                self.searchResults = []
            }
            
            isSearching = false
        }
        
    }
}

struct ResultCell: View{
    let song: SongDetail
    var onAddTap: () -> Void
    var body: some View {
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
            
            Button(action: {
                onAddTap()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22))
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
            .buttonStyle(.borderless)
                
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    SearchView()
        .environment(MusicStore())
}
