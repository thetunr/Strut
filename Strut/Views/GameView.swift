//
//  GameView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.modelContext) private var modelContext

    let todaySteps: Step
    let refreshSteps: () async -> Void
    
    @State private var activeGroup: Int = -1
    @Binding var groups: [Group]
        
    var body: some View {
        VStack(spacing: 0) {
            GroupHeaderBar(activeGroup: $activeGroup, groups: $groups)
            
            // Blur between GameHeaderView & (FullView / GroupView)
            BlurBar(topColor: .grey80, bottomColor: .grey87, height: 5)
            
            ZStack(alignment: .top) {
                // Logic for FullView & GroupView
                if (activeGroup == -1) {
                    FullView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    GroupView(group: groups[activeGroup])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Components over game screen
                VStack {
                    // Floating horizontal bar on top, includes step count and refresh button
                    HStack(alignment: .top) {
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                            .frame(width: 32, height: 5) // width must match frame size of refresh button
                        
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)

                        // Floating steps count component
                        ZStack {
                            // Container for steps count text
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 200, height: 44)
                                .background(.grey2) // removed 0.5 opacity
                                .cornerRadius(22)
                                .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 4)
                            
                            // Steps count text
                            Text("\(todaySteps.count)")
                                .font(.custom("Inter-Regular", size: 30))
                                .frame(width: 130, height: 32)
                                .foregroundColor(Color.black)
                        }
                        
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                        
                        // Refresh button
                        Button(action: {
                            Task {
                                await self.refreshSteps()
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.grey2)
                                    .shadow(color: Color.primary.opacity(0.1), radius: 1, x: -2, y: 2)
                                
                                Image(.refreshIcon)
                                    .renderingMode(.template)
                                    .foregroundColor(.grey4)
                            }
                        })
                        .frame(width: 32, height: 32)
                    }
                    .padding(12)
                    
                    // Separates top and bottom bars over game screen
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)

                    HStack(alignment: .bottom) {
                        // Swipeable floating tab
                        ZStack {
                            VStack {
                                // TODO: need to create components, make swipeable
                                // Ranking / group total / time left
                                ZStack {
                                    Rectangle()
                                        .frame(width: 200, height: 50)
                                        .cornerRadius(25)
                                        .foregroundColor(.clear)
                                        .background(.grey2) // removed opacity
                                        .cornerRadius(25)
                                        .shadow(color: Color.primary.opacity(0.1), radius: 2, x: 0, y: 4)
                                    
                                    Text("1   2   3")
                                        .foregroundColor(.grey4)
                                }
                                
                                // Three dots indicator
                                HStack(spacing: 3) {
                                    Circle()
                                        .foregroundColor(Color.primary.opacity(0.65))
                                        .frame(width: 3, height: 3)
                                    
                                    Circle()
                                        .foregroundColor(Color.primary.opacity(0.25))
                                        .frame(width: 3, height: 3)
                                    
                                    Circle()
                                        .foregroundColor(Color.primary.opacity(0.25))
                                        .frame(width: 3, height: 3)
                                }
                                .frame(height: 0)
                            }
                        }
                        
                        Spacer(minLength: 0)
                        
                        // Inventory
                        ZStack {
                            Button(action: {
                                Task {
                                    
                                }
                            }, label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 85, height: 85)
                                        .foregroundColor(.grey2) // removed opacity
                                        .shadow(color: Color.primary.opacity(0.1), radius: 1, x: 0, y: 2)
                                    
                                    Text("inventory")
                                        .font(.system(size: 12))
                                        .foregroundColor(.grey4)
                                }
                            })
                        }
                    }
                    .padding(12)
                }
            }
        }
    }
}
