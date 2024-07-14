//
//  TempStepsListView.swift
//  Strut
//
//  Created by Tony Oh on 7/14/24.
//

import SwiftUI

struct TempStepsListView: View {
    let steps: [Step]
    let healthStore: HealthStore
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
                .stroke(.grey71, lineWidth: 1)
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
                            .foregroundColor(.black.opacity(0.75))
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
