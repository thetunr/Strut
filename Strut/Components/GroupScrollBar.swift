//
//  GroupScrollBar.swift
//  Strut
//
//  Created by Tony Oh on 7/12/24.
//

import SwiftUI

struct GroupScrollBar: View {
    @Binding var activeFriendGroup: Int
    @Binding var friendGroups: [FriendGroup]
    var fullViewButtonWidth: CGFloat = 58

    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(friendGroups.indices, id: \.self) { index in
                        Button(
                            action: {
                                withAnimation(.snappy) {
                                    activeFriendGroup = index
                                    print(friendGroups[index].name)
                                }
                            },
                            label: {
                                // TODO: insert Group profile images
                                ZStack {
                                    Circle()
                                        .foregroundColor(
                                            activeFriendGroup == index ? .grey3 : .grey1
                                        )
                                        .frame(width: 40, height: 40)
                                    Text(friendGroups[index].emoji)
                                }
                            })
                    }
                }
                .padding(.trailing, 10)
            }
            .contentMargins(.leading, fullViewButtonWidth * 1.15)

            // FullView button
            ZStack(alignment: .center) {
                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 25, topTrailing: 25))
                    .fill(Color(.blue2))
                    .frame(width: fullViewButtonWidth, height: 44)

                Button(
                    action: {
                        withAnimation(.snappy) {
                            activeFriendGroup = -1
                            print("Full")
                        }
                    },
                    label: {
                        Image(.usersIcon)
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundStyle(activeFriendGroup == -1 ? .grey1 : .grey3)
                            .offset(x: -2)
                    })
            }

        }
        .frame(height: 60)  // frame of entire ZStack horizontal bar
        .padding(.top, 5)
    }
}
