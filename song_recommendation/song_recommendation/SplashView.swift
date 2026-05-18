//
//  SplashView.swift
//  song_recommendation
//
//  Created by cpsc on 5/5/26.
//

// For Future code/project post graduation
import SwiftUI
import Foundation
import SwiftData
import Supabase


enum connectionStatus {
    case loading
    case success
    case failure
    
    var message: String {
        switch self {
        case .loading:
            return "Loading..."
        case .success:
            return "Success"
        case .failure:
            return "Failed"
        }
    }
    
}

struct SplashView: View {
    
    @State private var isActive  = false
    
    var body: some View {
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
                Text("VibeScroll")
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
                Text("Find your frequency")
                    .font(.title2)
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

#Preview {
    SplashView()
}

