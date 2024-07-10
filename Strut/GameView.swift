//
//  GameView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @EnvironmentObject var manager: HealthManager
    @Environment(\.modelContext) private var modelContext

    @State private var activeGroup: Int = -1
    
    @State private var groups: [Group] = [
        Group(name: "Group 1", dateCreated: Date(), members: [Friend(user: "username1", name: "friend1", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 2", dateCreated: Date(), members: [Friend(user: "username2", name: "friend2", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 3", dateCreated: Date(), members: [Friend(user: "username3", name: "friend3", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 4", dateCreated: Date(), members: [Friend(user: "username4", name: "friend4", dateJoined: Date.now, dateAdded: Date.now)]),
        Group(name: "Group 5", dateCreated: Date(), members: [Friend(user: "username5", name: "friend5", dateJoined: Date.now, dateAdded: Date.now)])
    ]
        
    var body: some View {
        VStack {
            GameHeaderView()

            VStack(spacing: 0) {
                CustomTabBar()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 5)
                    .blur(radius: 1)
            }
            
            ZStack {
                if (activeGroup == -1) {
                    FullView()
                        .border(Color.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.blue)
                            .border(Color.pink)
                }
                else {
                    GroupView(group: groups[activeGroup])
                        .border(Color.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.blue)
                            .border(Color.pink)
                }
                
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 50, height: 25)
            }
            
            Spacer()

        }
    }
    
    // Move Scrollable TabBar into GameHeaderView while maintaining activeGroup:
    // ChildView(activeGroup: $activeGroup)
    // @Binding var activeGroup: Int

    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack {
            ZStack(alignment: .center) {
                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                    .fill(Color(red: 0.71, green: 0.71, blue: 0.71))
                    .frame(width: 40, height: 30)
                    .background(Color.clear)
                
                Button(action: {
                    withAnimation(.snappy) {
                        activeGroup = -1
                        print("Full")
                    }
                    
                }){
                    
                    Image(.usersFull)
                        .renderingMode(.template) // Ensure the image is rendered as a template
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Maintain the aspect ratio
                        .frame(width: 16, height: 16) // Set the desired width and height
                        .foregroundStyle(activeGroup == -1 ? Color(UIColor.label) : .gray)
                        .offset(x: -1) // Adjust the offset to center the image towards the right
                        .background(Color.clear)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(groups.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.snappy) {
                                activeGroup = index
                                print(groups[index].name)
                            }
                            
                        }) {
                            Text(groups[index].emoji)
//                            Text(groups[index].name)
//                                .padding(.vertical, 12)
//                                .foregroundStyle(activeGroup == index ? Color.primary : .gray)
//                                .contentShape(.rect)
                            Text("\(index)")
                                .padding(.vertical, 12)
                                .foregroundStyle(activeGroup == index ? Color.primary : .gray)
                                .contentShape(.rect)
                        }
                    }
                }
            }
        }
//        .padding(.horizontal, 10)
    }
}

#Preview {
    GameView()
}
