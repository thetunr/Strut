//
//  FriendsView.swift
//  Strut
//
//  Created by Tony Oh on 7/15/24.
//

import SwiftData
import SwiftUI

struct FriendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var friends: [Friend]

    var body: some View {
        VStack {
            NavigationSplitView {
                List {
                    ForEach(friends) { friend in
                        NavigationLink {
                            Text(
                                "Friend named \(friend.name)."
                            )
                        } label: {
                            Text(friend.name)
                        }
                    }
                    .onDelete(perform: deleteFriends)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addFriend) {
                            Label("Add Friend", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select an item")
            }
        }
    }

    private func addFriend() {
        withAnimation {
            let newFriend = Friend(
                user: "username", name: "friend", dateJoined: Date(), dateAdded: Date())
            modelContext.insert(newFriend)
        }
    }

    private func deleteFriends(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(friends[index])
            }
        }
    }
}
