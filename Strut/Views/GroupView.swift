//
//  GroupView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct GroupView: View {
    let friendGroup: FriendGroup

    var body: some View {
        VStack {
            VStack {
                Text("Emoji: \(friendGroup.emoji)")
                Text("\(friendGroup.name) view")
                List(friendGroup.members) { member in
                    Text("\(member.name)")
                }
                .listStyle(.plain)
            }
            .frame(height: 300)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.grey87))
    }
}
