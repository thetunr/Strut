//
//  HomeView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel
    @State private var healthStore = HealthStore()

    @Query(sort: \Step.dateString, order: .reverse) var steps: [Step]
    @State private var activeTab: Int = 1

    @Query private var friends: [Friend]
    @State private var friendGroups: [FriendGroup] = [
        FriendGroup(
            dateCreated: Date(), name: "Group 1", emoji: "😶‍🌫️",
            members: [
                Friend(user: "username1", name: "friend1", dateJoined: Date(), dateAdded: Date()),
                Friend(user: "username2", name: "friend2", dateJoined: Date(), dateAdded: Date()),
                Friend(user: "username3", name: "friend3", dateJoined: Date(), dateAdded: Date()),
            ]),
        FriendGroup(
            dateCreated: Date(), name: "Group 2", emoji: "🤭",
            members: [
                Friend(user: "username4", name: "friend4", dateJoined: Date(), dateAdded: Date()),
                Friend(user: "username5", name: "friend5", dateJoined: Date(), dateAdded: Date()),
            ]),
        FriendGroup(
            dateCreated: Date(), name: "Group 3", emoji: "🐧",
            members: [
                Friend(user: "username6", name: "friend6", dateJoined: Date(), dateAdded: Date())
            ]),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Logic for different tabs
            if activeTab == 1 {
                GameView(
                    todaySteps: steps.first?.count ?? 0,
                    refreshSteps: self.refreshSteps,
                    friendGroups: $friendGroups)  // TODO: not the best solution with optionals
            } else if activeTab == 2 {
                FriendsView()
                // ContentView()
            } else if activeTab == 3 {
                TempStepsListView(refreshSteps: self.refreshSteps)
                    .environment(viewModel)

            }

            BlurBar(topColor: .grey87, bottomColor: .grey80, height: 5)

            CustomTabBar(activeTab: $activeTab)
        }
        .task {
            await healthStore.requestAuthorization()
            await refreshSteps(numDays: 7)
        }
    }

    @MainActor
    func refreshSteps(numDays: Int) async {
        Task {
            Task {
                healthStore.healthKitSteps = []
                do {
                    try await healthStore.fetchSteps(numDays: 7)
                } catch {
                    print(error)
                }
            }

            Task {
                let id = viewModel.user?.uid ?? ""

                for step in healthStore.healthKitSteps {
                    let step = Step(date: step.date, userID: id, count: step.count)
                    modelContext.insert(step)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
