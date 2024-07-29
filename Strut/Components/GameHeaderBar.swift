//
//  GroupHeaderBar.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct GroupHeaderBar: View {

    @Binding var activeFriendGroup: Int
    @Binding var friendGroups: [FriendGroup]

    @State private var progress = 0.7

    var body: some View {
        VStack(spacing: 0) {  // Vertically stacking fish bar & GroupScrollBar
            HStack {  // Whole horizontal fish bar
                Spacer()

                // Fish icon
                Image(.fishIcon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(Color.primary)

                // TODO: create new loading component for rounder bar
                // ProgressView
                ProgressView(value: progress)
                    .frame(width: 260)
                    .tint(Color(.blue3))
                    .scaleEffect(x: 1, y: 2.5, anchor: .center)

                Spacer()
            }

            GroupScrollBar(activeFriendGroup: $activeFriendGroup, friendGroups: $friendGroups)
        }
        .padding(.top, 15)
        .background(Color(.blue1))
    }
}
