//
//  GameView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftData
import SwiftUI

struct GameView: View {
    @Environment(\.modelContext) private var modelContext

    let todaySteps: Step
    let refreshSteps: () async -> Void

    @State private var activeFriendGroup: Int = -1
    @Binding var friendGroups: [FriendGroup]

    var body: some View {
        VStack(spacing: 0) {
            GroupHeaderBar(activeFriendGroup: $activeFriendGroup, friendGroups: $friendGroups)

            // Blur between GameHeaderView & (FullView / GroupView)
            BlurBar(topColor: .grey80, bottomColor: .grey87, height: 5)

            ZStack(alignment: .top) {
                // Logic for FullView & GroupView
                if activeFriendGroup == -1 {
                    FullView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    GroupView(friendGroup: friendGroups[activeFriendGroup])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Components over game screen
                VStack {
                    // Floating horizontal stack on top, includes step count and refresh button
                    HStack(alignment: .top) {
                        Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)
                            .frame(width: 32, height: 5)  // width must match frame size of refresh button

                        Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

                        StepsDisplay(stepCount: self.todaySteps.count)

                        Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

                        // Refresh button
                        RefreshButton(refreshSteps: self.refreshSteps)
                    }
                    .padding(12)

                    // Separates top and bottom horizontal stacks over game screen
                    Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

                    HStack(alignment: .bottom) {
                        MultiSwipeableTab(
                            topThreeFriends: [
                                Friend(
                                    user: "Name", name: "Friend", dateJoined: Date(),
                                    dateAdded: Date())
                            ], totalGroupSteps: 96723)

                        Spacer(minLength: 0)

                        Inventory(
                            firstItem: Item(timestamp: Date()), secondItem: Item(timestamp: Date()),
                            thirdItem: Item(timestamp: Date()))  // TODO: add real items later
                    }
                    .padding(12)
                }
            }
        }
    }
}

// Components used in GameView
struct StepsDisplay: View {
    let stepCount: Int

    var body: some View {
        // Floating steps count component
        ZStack {
            // Container for steps count text
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 200, height: 44)
                .background(.grey2)  // removed 0.5 opacity
                .cornerRadius(22)
                .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 4)

            // Steps count text
            Text("\(stepCount)")
                .font(.custom("Inter-Regular", size: 30))
                .frame(width: 130, height: 32)
                .foregroundColor(Color.black)
        }
    }
}

struct RefreshButton: View {
    let refreshSteps: () async -> Void

    var body: some View {
        Button(
            action: {
                Task {
                    await self.refreshSteps()
                }
            },
            label: {
                ZStack {
                    Circle()
                        .foregroundColor(.grey2)
                        .shadow(color: Color.primary.opacity(0.1), radius: 1, x: -2, y: 2)

                    Image(.refreshIcon)
                        .renderingMode(.template)
                        .foregroundColor(.grey4)
                }
            }
        )
        .frame(width: 32, height: 32)
    }
}

struct MultiSwipeableTab: View {
    let topThreeFriends: [Friend]
    let totalGroupSteps: Int
    @State private var timeRemaining: String = ""
    @State private var timer: Timer?

    private func startTimer() {
        updateTimeRemaining()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimeRemaining()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
    }

    private func updateTimeRemaining() {
        let now = Date()
        let calendar = Calendar.current
        let nextMidnight = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: now)!)
        let components = calendar.dateComponents(
            [.hour, .minute, .second], from: now, to: nextMidnight)

        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0

        timeRemaining = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        ZStack {
            VStack {
                // TODO: need to create components, make swipeable
                // Ranking / group total / time left
                ZStack {
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .cornerRadius(25)
                        .foregroundColor(.clear)
                        .background(.grey2)  // removed opacity
                        .cornerRadius(25)
                        .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 4)

                    Text(timeRemaining)
                        .onAppear(perform: startTimer)
                        .onDisappear(perform: stopTimer)
                        .foregroundColor(.grey4)
                }

                // Three dots indicator
                HStack(spacing: 3) {
                    Circle()
                        .foregroundColor(Color.primary.opacity(0.65))
                        .frame(width: 3, height: 3)

                    Circle()
                        .foregroundColor(Color.primary.opacity(0.25))
                        .frame(width: 3, height: 3)

                    Circle()
                        .foregroundColor(Color.primary.opacity(0.25))
                        .frame(width: 3, height: 3)
                }
                .frame(height: 0)
            }
        }
    }
}

struct Inventory: View {
    let firstItem: Item
    let secondItem: Item
    let thirdItem: Item

    var body: some View {
        ZStack {
            Button(
                action: {
                    Task {

                    }
                },
                label: {
                    ZStack {
                        Circle()
                            .frame(width: 85, height: 85)
                            .foregroundColor(.grey2)  // removed opacity
                            .shadow(color: Color.primary.opacity(0.1), radius: 1, x: 0, y: 2)

                        Text("inventory")
                            .font(.system(size: 12))
                            .foregroundColor(.grey4)
                    }
                })
        }
    }
}
