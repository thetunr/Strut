//
//  HealthManager.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import Foundation
import HealthKit
import SwiftData

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    
    init() {
        let steps = HKQuantityType(.stepCount)
        
        let healthTypes: Set = [steps]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            }
            catch {
                print("error fetching health data")
            }
        }
    }
    
    func fetchSteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) {_, stats, error in
            guard let quantity = stats?.sumQuantity(), error == nil else {
                print("error fetching steps data")
                return
            }
            let stepCount = quantity.doubleValue(for: .count())
            print(stepCount)
        }
        healthStore.execute(query)
    }
    
}

