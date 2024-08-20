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
        HStack(spacing: 45) {
            Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

            Button(action: {
                activeTab = 1
            }) {
                ZStack {
                    Image(.mapIcon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 48, height: 48)
            }
            .padding(.leading, 20)
            .foregroundColor(activeTab == 1 ? .blue4 : .grey1)

            Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

            Button(action: {
                activeTab = 2
            }) {
                ZStack {
                    Image(.friendsIcon)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 48, height: 48)
            }
            .foregroundColor(activeTab == 2 ? .blue4 : .grey1)

            Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)

            Button(action: {
                activeTab = 3
            }) {
                ZStack {
                    Image(systemName: "person.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 48, height: 48)
            }
            .padding(.trailing, 20)
            .foregroundColor(activeTab == 3 ? .blue4 : .grey1)

            Spacer(minLength: /*@START_MENU_TOKEN@*/ 0 /*@END_MENU_TOKEN@*/)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .background(.blue1)
    }
}

#Preview {
    CustomTabBar(activeTab: .constant(1))
}
