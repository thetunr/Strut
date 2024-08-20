//
//  NewStep.swift
//  Strut
//
//  Created by Tony Oh on 8/18/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class NewStep: Identifiable {
    @Attribute(.unique) var dateString: String
    var userID: String
    var count: Int

    init(date: Date, userID: String, count: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.dateString = dateFormatter.string(from: date)
        //        self.date = date
        self.userID = userID
        self.count = count
    }
}
