//
//  SuparbaseManager.swift
//  song_recommendation
//
//  Created by cpsc on 5/5/26.
//

import Foundation
import SwiftUI
import Supabase


// Class for managing Supabase Database
class SupabaseManager {
    
    // Ensures there can only be one SupabaseManager
  static let shared = SupabaseManager()
    
    // Creates client that connects to supabase database
    let client = SupabaseClient(
        supabaseURL: URL(string: Secrets.supabaseUrl)!,
        supabaseKey: Secrets.supabaseKey
    )
    
    // Initializing getting updated preview links from iTunes
    init() {
        Task {
            await updateAPI()
        }
    }
    
    // Function for testing database connection
    func testPublicConnection() async -> Bool {
        do {
            let response: [SongDetail] = try await client
                .from("music_info") // Tries to retrieve something from the database to test connection
                .select("track_id, name, artist, itunes_preview")
                .limit(5)
                .execute()
                .value
            print("\(response.first!.name)") // Prints out the name of the song to make sure
            print("The database has been connected")
            return true
        }
        catch { // Catch statement incase there is no connection
            print("The database is not connected")
            return false
        }
    }
    
    // Function for getting/updating the preview links from iTunes
    func updateAPI() async {
        
        var running = true // Bool variable to keep updating
        
        while running {
            print("Starting update") // Print statement to ensure code is running
            
            do { // Query that gets the track_id, name and artist information from all the songs that have itunes_preview as NULL
                let response: [SongDetail] = try await client
                    .from("music_info")
                    .select("track_id, name, artist, itunes_preview")
                    .is("itunes_preview", value: nil)
                    .limit(50) // Limits to 50 songs per query
                    .execute()
                    .value
                
                print("Updating \(response.count) songs.")
                
                // Stops loop if there are no more rows with itunes_preview as NULL
                if response.isEmpty {
                    print("No more songs needed to update")
                    running = false
                }
                
                // Loops through all songs from query response
                for song in response {
                    
                    do {
                        let songName = song.name // stores the name of the song
                        let songArtist = song.artist // stores the artist name
                        
                        print("Updating \(songName) by \(songArtist)")
                        let searchInput = "\(songName) \(songArtist)"
                        
                        // Guard statement safely handles for special characters from songName and artistName, then creates the url for the song preview
                        guard let encoded = searchInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                              let url = URL(string: "https://itunes.apple.com/search?term=\(encoded)&entity=song&limit=1") // url limits to top result
                        else {
                            continue // Skips song if url creation fails
                        }
                        
                        let (data, response) = try await URLSession.shared.data(from: url) // Fetches 
                        
                        // Prints out server response to double check if the server is letting me get the preview links
                        if let httpsResponse = response as? HTTPURLResponse {
                            if httpsResponse.statusCode == 403 {
                                print("Server Response: \(httpsResponse.statusCode)")
                                try? await Task.sleep(nanoseconds: 100_000_000_000)
                                throw NSError(domain: "AppleRateLimite", code: 403)
                            }
                        }
                        
                        // Decodes recevied data from server which will be inputted into Supabase
                        print("Starting to decode data")
                        let itunesResult = try JSONDecoder().decode(iTunesResponse.self, from: data)
                        print("Decoded data")
                        let previewLink = itunesResult.results?.first?.previewUrl ?? "NOT_FOUND"
                        
                    
                        // Updating Supabase with new preview links
                        try await client
                            .from("music_info")
                            .update(["itunes_preview": previewLink])
                            .eq("track_id", value: song.track_id)
                            .execute()
                        
                        print("Successfully updated: \(songName) by \(songArtist)")
                        
                        // Gives a delay every time it works so that server does not blcok me
                        try? await Task.sleep(nanoseconds: 5_000_000_000)

                    } catch {
                        // If I get a error 403 thern prints failure
                        print("Failed to process song")
                        if (error as NSError).code == 403 {
                            break
                        }
                    }
                }
            } catch {
                // If i get a failure then there is another delay before I try to get data again from the server
                print("Batch failed. Error: \(error.localizedDescription)")
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }
    }
    // Function for searching songs. Runs function from supabase that retries needed details for array of SongDetail
    func searchSongs(query: String) async throws -> [SongDetail] {
        let safeQuery = "%\(query)%"
        let results: [SongDetail] = try await client
            .from("music_info")
            .select("track_id, name, artist, itunes_preview")
            .or("name.ilike.\(safeQuery),artist.ilike.\(safeQuery)")
            .limit(50)
            .execute()
            .value
        
        return results
    }
}

// Structure that stores response from iTunes when making query
struct iTunesResponse: Codable {
    let results: [iTunesTrack]?
}

// Structure that stores the preview link from iTunes
struct iTunesTrack: Codable {
    let previewUrl: String?
}

