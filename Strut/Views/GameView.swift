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

    let todaySteps: Int
    let refreshSteps: (Int) async -> Void

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

                        StepsDisplay(stepCount: self.todaySteps)

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
                            ], totalGroupSteps: "96723")

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
    let refreshSteps: (Int) async -> Void

    var body: some View {
        Button(
            action: {
                Task {
                    await self.refreshSteps(1)
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
    @State private var scrollPosition: Int? = 1

    let topThreeFriends: [Friend]

    let totalGroupSteps: String

    @State private var timeRemaining: String = ""
    @State private var timer: Timer?

    var body: some View {
        VStack {
            // Ranking / group total / time left
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(.grey2)  // removed opacity

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        HStack(alignment: .bottom, spacing: 4) {
                            Text("1")
                                .font(.custom("Inter-Regular", size: 42))
                            Circle()
                                .frame(width: 32, height: 32)
                                .padding(.bottom, 4)
                                .foregroundColor(Color.grey3)  // TODO: later change foregroundColor

                            Text("2")
                                .font(.custom("Inter-Regular", size: 36))
                            Circle()
                                .frame(width: 28, height: 28)
                                .padding(.bottom, 4)
                                .foregroundColor(Color.grey3)

                            Text("3")
                                .font(.custom("Inter-Regular", size: 36))
                            Circle()
                                .frame(width: 28, height: 28)
                                .padding(.bottom, 4)
                                .foregroundColor(Color.grey3)
                        }
                        .frame(width: 200, height: 50)
                        .id(1)

                        VStack(alignment: .center) {
                            Text("group total:")
                                .font(.custom("Inter-Regular", size: 8))
                            Text(totalGroupSteps)
                                .font(.custom("Inter-Regular", size: 28))
                        }
                        .frame(width: 200, height: 50)
                        .id(2)

                        VStack(alignment: .center) {
                            Text("time remaining:")
                                .font(.custom("Inter-Regular", size: 8))
                            Text(timeRemaining)
                                .font(.custom("Inter-Regular", size: 28))
                        }
                        .frame(width: 200, height: 50)
                        .id(3)
                        .onAppear(perform: startTimer)
                        .onDisappear(perform: stopTimer)
                    }
                }
                .frame(width: 200, height: 50)
                .scrollTargetLayout()
                .scrollTargetBehavior(.paging)
                .scrollBounceBehavior(.basedOnSize)
                .scrollPosition(id: $scrollPosition)
            }
            .frame(width: 200, height: 50)
            .cornerRadius(25)
            .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 4)

            // Three dots indicator
            HStack(spacing: 3) {
                Circle()
                    .foregroundColor(Color.primary.opacity(scrollPosition == 1 ? 0.65 : 0.25))
                    .frame(width: 3, height: 3)

                Circle()
                    .foregroundColor(Color.primary.opacity(scrollPosition == 2 ? 0.65 : 0.25))
                    .frame(width: 3, height: 3)

                Circle()
                    .foregroundColor(Color.primary.opacity(scrollPosition == 3 ? 0.65 : 0.25))
                    .frame(width: 3, height: 3)
            }
            .frame(height: 0)
        }
    }

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
