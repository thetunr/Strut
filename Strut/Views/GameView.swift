//
//  GameView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext

    let todaySteps: Step
    @State private var activeGroup: Int = -1
    @State private var groups: [Group] = [
        Group(name: "Group 1", dateCreated: Date(), members: [Friend(user: "username1", name: "friend1", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 2", dateCreated: Date(), members: [Friend(user: "username2", name: "friend2", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 3", dateCreated: Date(), members: [Friend(user: "username3", name: "friend3", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 4", dateCreated: Date(), members: [Friend(user: "username4", name: "friend4", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 5", dateCreated: Date(), members: [Friend(user: "username5", name: "friend5", dateJoined: Date.now, dateAdded: Date.now)])
    ]
        
    var body: some View {
        VStack(spacing:0) {
            GameHeaderView(activeGroup: $activeGroup, groups: $groups)
            
            // Blur between GameHeaderView & (FullView / GroupView)
            BlurBar(topColor: .grey80, bottomColor: .grey87, height: 5)
            
            ZStack(alignment: .top) {
                // Logic for FullView & GroupView
                if (activeGroup == -1) {
                    FullView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.grey87))
                }
                else {
                    GroupView(group: groups[activeGroup])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.grey87))
                }
                
                // Floating steps count component
                ZStack {
                    // Container for steps count text
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 190, height: 44)
                        .background(Color(.grey98).opacity(0.5))
                        .cornerRadius(22)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
                    
                    // Steps count text
                    Text("\(todaySteps.count)")
                        .font(.custom("Inter-Regular", size: 30))
                        .frame(width: 130, height: 32)
                        .foregroundColor(.black)
                    
                    
                }
                .padding(.top, 10) // Move step count down
            }
        }
    }
}

#Preview {
    GameView(todaySteps: Step(count: 0, date: Date()))
}
