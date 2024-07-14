//
//  Friend.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import Foundation
import SwiftData
import SwiftUI

//struct Friend {
//    let user: String // fetch character, date joined / added, total steps through id
//    let name: String
//    let nickname: String
//}

//@Model
class Friend {
    let user: String
    let name: String
    let dateJoined: Date
    let dateAdded: Date
    @State var nickname: String?

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
