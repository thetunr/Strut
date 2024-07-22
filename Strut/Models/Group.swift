//
//  Group.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI
import SwiftData


//@Model
class Group {
    
    let dateCreated: Date
    @State var name: String
    @State var emoji: String
    @State var members: [Friend]

    init(dateCreated: Date, name: String, emoji: String, members: [Friend] ) {
        self.name = name
        self.dateCreated = dateCreated
        self.emoji = emoji
        self.members = members
    }
    
    func addFriend(friend: Friend) {
        self.members.append(friend)
    }
    
    func removeFriend(friend: Friend) {
        
    }
}
