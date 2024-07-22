//
//  HomeView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var healthStore = HealthStore()
    
    private var steps: [Step] {
        healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    @State private var activeTab: Int = 1
    
    @State private var friends: [Friend] = [
        Friend(user: "username1", name: "friend1", dateJoined: Date(), dateAdded: Date()),
        Friend(user: "username2", name: "friend2", dateJoined: Date(), dateAdded: Date()),
        Friend(user: "username3", name: "friend3", dateJoined: Date(), dateAdded: Date()),
        Friend(user: "username4", name: "friend4", dateJoined: Date(), dateAdded: Date()),
        Friend(user: "username5", name: "friend5", dateJoined: Date(), dateAdded: Date()),
        Friend(user: "username6", name: "friend6", dateJoined: Date(), dateAdded: Date())
    ]
    
    @State private var groups: [Group] = [
        Group(dateCreated: Date(), name: "Group 1", emoji: "😶‍🌫️", members: [
            Friend(user: "username1", name: "friend1", dateJoined: Date(), dateAdded: Date()),
            Friend(user: "username2", name: "friend2", dateJoined: Date(), dateAdded: Date()),
            Friend(user: "username3", name: "friend3", dateJoined: Date(), dateAdded: Date())
        ]),
        Group(dateCreated: Date(), name: "Group 2", emoji: "🤭", members: [
            Friend(user: "username4", name: "friend4", dateJoined: Date(), dateAdded: Date()),
            Friend(user: "username5", name: "friend5", dateJoined: Date(), dateAdded: Date())
        ]),
        Group(dateCreated: Date(), name: "Group 3", emoji: "🐧", members: [
            Friend(user: "username6", name: "friend6", dateJoined: Date(), dateAdded: Date())
        ])
    ]
    
    init() {
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Logic for different tabs
            if (activeTab == 1) {
                GameView(todaySteps: self.steps.first ?? Step(count: 0, date: Date()), 
                         refreshSteps: self.refreshSteps,
                         groups: $groups) // TODO: not the best solution with optionals
            } else if (activeTab == 2) {
                FriendsView()
            }
            else if (activeTab == 3) {
//                ContentView()
                TempStepsListView(steps: self.steps, refreshSteps: self.refreshSteps)
            }
            
            BlurBar(topColor: .grey87, bottomColor: .grey80, height: 5)
            
            CustomTabBar(activeTab: $activeTab)
        }
        .task {
            await healthStore.requestAuthorization()
            await refreshSteps()
        }
    }
    
    func refreshSteps() async {
        Task {
            do {
                healthStore.steps = []
                try await healthStore.fetchSteps()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
