//
//  HomeView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    @State private var activeTab: String = "Game"
    
    var body: some View {
        TabView(selection: $activeTab) {
            GameView()
                .tag("Game")
                .tabItem {
                    Image(systemName: "house")
                }
                .environmentObject(manager)
//                .ignoresSafeArea()
            
            ContentView()
                .tag("Content")
                .tabItem {
                    Image(systemName: "person.2.fill")
                }
            
            ContentView()
                .tag("Settings")
                .tabItem {
                    Image(systemName: "person.circle.fill")
                }
        }
        .shadow(radius: 3)
        
        .onAppear {
            manager.fetchSteps()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HealthManager())
}
