//
//  HomeView.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var healthStore = HealthStore()
    
    private var steps: [Step] {
        healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    @State private var activeTab: Int = 3
    
    init() {
        
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Logic for different tabs
            if (activeTab == 1) {
                GameView(todaySteps: self.steps.first ?? Step(count: 0, date: Date()))
            } else if (activeTab == 2) {
                ContentView()
            }
            else if (activeTab == 3) {
                TempStepsListView(steps: self.steps, healthStore: self.healthStore, refreshSteps: self.refreshSteps)
            }
            
            BlurBar(topColor: .grey87, bottomColor: .grey80, height: 5)
            
            CustomTabBar(activeTab: $activeTab)
        }
        .task {
            await healthStore.requestAuthorization()
            
        }
    }
    
    func refreshSteps() async {
        Task {
            do {
                healthStore.steps = []
                try await healthStore.fetchSteps()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
