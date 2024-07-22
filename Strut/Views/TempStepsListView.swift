//
//  TempStepsListView.swift
//  Strut
//
//  Created by Tony Oh on 7/14/24.
//

import SwiftUI
//import AuthenticationServices
import Firebase
//import CryptoKit

struct TempStepsListView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    
    
    let steps: [Step]
    let refreshSteps: () async -> Void
    
    var body: some View {
        
        VStack {
            List(steps) { step in
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(step.count < 10000 ? .red : .green)
                    Text("\(step.count)")
                    Spacer()
                    Text(step.date.formatted(date: .abbreviated, time: .complete))
                }
            }
            .listStyle(.plain)
            
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.grey87)
                .stroke(.grey4, lineWidth: 1)
                .padding(10)
                .foregroundColor(.black)
                .frame(width: 100, height: 50)
                .overlay(
                    Button(action: {
                        Task {
                            await self.refreshSteps()
                        }
                    }, label: {
                        Text("Refresh")
                            .foregroundColor(.primary.opacity(0.75))
                    })
                )
            
            Spacer(minLength: 30)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.grey87)
                .stroke(.grey4, lineWidth: 1)
                .padding(10)
                .foregroundColor(.black)
                .frame(width: 100, height: 50)
                .overlay(
                    Button(action: {
                        Task {
                            do {
                                try Auth.auth().signOut()
                                isLoggedIn = false
                                print("Log out")
                            }
                            catch {
                                print(error)
                            }
                        }
                    }, label: {
                        Text("Log out")
                            .foregroundColor(.primary.opacity(0.75))
                    })
                )
            
            Spacer(minLength: 30)
        }
        .onAppear {
            Task {
                await self.refreshSteps()
            }
        }
    }
}
