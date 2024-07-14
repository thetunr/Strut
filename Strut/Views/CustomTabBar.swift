//
//  CustomTabBar.swift
//  Strut
//
//  Created by Tony Oh on 7/13/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var activeTab: Int
    
    var body: some View {
        HStack(spacing: 50) {
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                activeTab = 1
            }) {
                Image(.mapIcon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 22)
            }
            .foregroundColor(Color.black.opacity(activeTab == 1 ? 1 : 0.5))
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                activeTab = 2
            }) {
                Image(.fishIcon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)

            }
            .foregroundColor(Color.black.opacity(activeTab == 2 ? 1 : 0.5))
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                activeTab = 3
            }) {
                Image(systemName: "person.circle.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .foregroundColor(Color.black.opacity(activeTab == 3 ? 1 : 0.5))
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
        }
        .padding(.top, 15) // top padding of CustomTabBar
        .background(.grey93)
    }
}

//#Preview {
//    CustomTabBar()
//}
