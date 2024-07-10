//
//  GroupView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct GroupView: View {
    let group: Group
    
    var body: some View {
        VStack {
            Text("Emoji: \(group.emoji)")
            Text("\(group.name) view")
            Text("First friend in group is \(group.members[0].name).")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    GroupView(
        group: Group(name: "Group 1", dateCreated: Date(), members: [Friend(user: "username1", name: "friend1", dateJoined: Date.now, dateAdded: Date.now)])
    )
}
