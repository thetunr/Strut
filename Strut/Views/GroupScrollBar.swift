//
//  GroupScrollBar.swift
//  Strut
//
//  Created by Tony Oh on 7/12/24.
//

import SwiftUI

struct GroupScrollBar: View {
    @Binding var activeGroup: Int
    @Binding var groups: [Group]
    var fullViewButtonWidth: CGFloat = 58
    
    var body: some View {
        ZStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(groups.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.snappy) {
                                activeGroup = index
                                print(groups[index].name)
                            }
                            
                        }) {
                            // TODO: insert Group profile images
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(.grey85))
                                    .frame(width: 40, height: 40)
                                Text(groups[index].emoji)
                            }
                            
                        }
                    }
                }
            }
            .contentMargins(.leading, fullViewButtonWidth * 1.2)
            
            ZStack(alignment: .center) {
                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 25, topTrailing: 25))
                    .fill(Color(.grey71))
                    .frame(width: fullViewButtonWidth, height: 44)
                    .background(Color.clear)
                
                Button(action: {
                    withAnimation(.snappy) {
                        activeGroup = -1
                        print("Full")
                    }
                }) {
                    Image(.usersIcon)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundStyle(activeGroup == -1 ? Color(UIColor.systemBackground) : .gray)
                        .offset(x: -2)
                }
            }
            
        }
        .frame(height: 60) // frame of entire ZStack horizontal bar
        .padding(.top, 5)
    }
    
}

//#Preview {
//    GroupScrollBar()
//}
