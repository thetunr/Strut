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
        // TODO: create new TabView for easier customization
        TabView(selection: $activeTab) {
            GameView()
                .tag("Game")
                .tabItem {
                    Image(.mapIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 8, height: 8)
//                        .renderin?gMode(.template)
                }
                .environmentObject(manager)
                .onAppear {
                    manager.fetchSteps()
                }
            
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
        // TODO: delete later, temporary solution for color
        .tint(.pink)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = .systemBrown
            UITabBarItem.appearance().badgeColor = .systemPink
            UITabBar.appearance().backgroundColor = UIColor(Color(.grey93))
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
                })
        
    }
}

#Preview {
    HomeView()
        .environmentObject(HealthManager())
}
