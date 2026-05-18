//
//  AudioManager.swift
//  song_recommendation
//
//  Created by cpsc on 5/16/26.
//

import Foundation
import AVFoundation

@Observable class AudioManager {
    
    static let shared = AudioManager() // Ensures there is only one AudioManager for the whole app
    
    private var player: AVPlayer?  // Object that actually gets in the preview links to play the song
    private var timeObserver: Any? // Object needed for song duration
    var currentTrack: (any PlayableSong)? = nil // keeps track of current track
    var currentTime: Double = 0.0 // Keeps track of the current time
    var totalDuration: Double = 0.0 // Stores total duration of song
    private var currentIndex = 0 // Keeps track of the current index of the song in the playlist
    var isPlaying: Bool = false // Boolean that keeps track if the playlist is actually playing
    private var songQueue: [any PlayableSong] = [] // Keeps track of the whole playlists song clue
    
    init() { // Initializer that initializes the AVPlayer
        self.player = AVPlayer()
    }
    
    // Function that places the actual song, with the song that is suppose to be playing and the whole queue as the input
    func playSong(_ firstSong: any PlayableSong, playlistSong: [any PlayableSong]) {
        
        // Removes old time obsever of previous song if that already existed
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        // Assings songQueue to the inputted queue
        self.songQueue = playlistSong
        
        // Assigns currentIndex based on the position of the inputted song within the playlist
        currentIndex = playlistSong.firstIndex(where: { $0.track_id == firstSong.track_id}) ?? 0
        
        // Guard statement to check if song has audip
        guard let urlString = firstSong.itunes_preview, let url = URL(string: urlString) else {
            print("No Audio")
            return
        }
        
        player?.pause() // Pauses any already existing song
        
        // Replaces previous song with the current song
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        
        // updates current track
        currentTrack = firstSong
        
        // Player plays song
        player?.play()
        isPlaying = true
        
        // Method for tracking duration
        trackProgress()
        
    }
    
    // Method for pausing/resuming
    func pauseSong() {
        // Uses boolean variable to check if it is playing. Resumes or pauses player based on it.
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
    }
    
    // Function that plays the next song in the queue using index
    func skipSong() {
        if currentIndex < songQueue.count - 1 {
            let nextSong = songQueue[currentIndex + 1]
            playSong(nextSong, playlistSong: songQueue)
        }
    }
    
    // Function that goes to previous song. If the song just started it would just repeat the song
    func previousSong() {
        if currentTime > 3.0 {
            seek(to: 0.0)
            return
        }
        
        // Also bases previous song based on index
        if currentIndex > 0 {
            let prevSong = songQueue[currentIndex - 1]
            playSong(prevSong, playlistSong: songQueue)
        }
    }
    
    private func trackProgress() {
        // Removes any current instance of timeObserver if that was already made
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        
        // Tracks the time based on 0.1 second
        let interval = CMTime(value: 1, timescale: 10)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let currentItem = self.player?.currentItem else { return }
            
            // Updates time and total duration based on the song and the progress made
            self.currentTime = time.seconds
            self.totalDuration = currentItem.duration.seconds
            
            // If the song is close to ending then the song moves on to the next one in queue
            if !self.totalDuration.isNaN {
                if self.currentTime >= (self.totalDuration - 0.1) {
                    self.skipSong()
                }
            }
            
        }
    }
    
    // function that allows user to skip to desired part of the song based on the users interaction with the slider
    func seek (to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 100)
        player?.seek(to: cmTime)
    }
}
