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
            VStack {
                Text("Emoji: \(group.emoji)")
                Text("\(group.name) view")
                List(group.members) { member in
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
