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
//@Model
class Friend: Identifiable {
    let user: String
    let name: String
    let dateJoined: Date
    let dateAdded: Date
    var nickname: String?

    init(user: String, name: String, dateJoined: Date, dateAdded: Date) {
        self.user = user
        self.name = name
        self.nickname = Optional.none
        self.dateJoined = dateJoined
        self.dateAdded = dateAdded
    }
    
    func changeNickname(newNickname: String?) {
        self.nickname = newNickname
    }
}
