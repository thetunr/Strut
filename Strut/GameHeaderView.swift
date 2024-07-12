//
//  GroupHeaderView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct GameHeaderView: View {

    @Binding var activeGroup: Int
    @Binding var groups: [Group]
    
    @State private var progress = 0.7

    var body: some View {
        VStack(spacing: 0) { // Vertically stacking fish bar & GroupScrollBar
            HStack { // Whole horizontal fish bar
                Spacer()
                
                // Fish icon
                Image(.fishIcon)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                
                // ProgressView
                ProgressView(value: progress)
                    .frame(width: 260)
                    .tint(Color(.grey71))
                    .scaleEffect(x: 1, y: 2.5, anchor: .center)
                
                Spacer()
            }
            
            GroupScrollBar(activeGroup: $activeGroup, groups: $groups)
        }
        .padding(.top, 8)
        .background(Color(.grey93))
    }
}

//#Preview {
//    GameHeaderView()
//}
