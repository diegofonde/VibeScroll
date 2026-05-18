//
//  PresentationCard.swift
//  song_recommendation
//
//  Created by cpsc on 5/18/26.
//

// Code for presentation card that shows the logo, name of app, name of student and goal of app
import SwiftUI

struct PresentationCard: View {
    
    var body: some View {
        ZStack {
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 80))
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
                    Text("App Name: VibeScroll")
                        .font(.system(.largeTitle, design:.rounded))
                        .fontWeight(.bold)
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
                        .padding()
                    Text("Student Name: Diego Fondevilla")
                        .font(.system(.largeTitle, design:.rounded))
                        .fontWeight(.bold)
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
                        .padding()
                    Text("App Goal: Simulate other music streaming platform like Spotify for personal project. Will eventually create Machine Learning Algorithms for it.")
                        .font(.system(.largeTitle, design:.rounded))
                        .fontWeight(.bold)
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
                        .padding()
                }
            }
        }
    }
}
