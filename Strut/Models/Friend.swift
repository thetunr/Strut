//
//  Friend.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import Foundation
import SwiftData
import SwiftUI

// TODO: figure out how to do this with group and friend
@Model
class Friend: Identifiable {
    var user: String
    var name: String
    var dateJoined: Date
    var dateAdded: Date
    var nickname: String?

    init(user: String, name: String, dateJoined: Date, dateAdded: Date) {
        self.user = user
        self.name = name
        self.nickname = Optional.none
        self.dateJoined = dateJoined
        self.dateAdded = dateAdded
    }
}
