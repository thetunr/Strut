//
//  HealthStore.swift
//  Strut
//
//  Created by Tony Oh on 7/8/24.
//

import Foundation
import HealthKit
import Observation
import SwiftData
import SwiftUI

@Observable
class HealthStore {
    var healthKitSteps: [HealthKitStep] = []
    var healthStore: HKHealthStore?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    @MainActor
    func fetchSteps(numDays: Int) async throws {
        guard let healthStore = self.healthStore else { return }

        let calendar = Calendar(identifier: .gregorian)

        guard let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: Date()) else { return }
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: tomorrowDate)
        guard let endDate = calendar.date(from: dateComponents) else { return }

        let startDate = calendar.date(byAdding: .day, value: -numDays, to: endDate)

        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)

        let sumofStepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate,
            intervalComponents: everyDay)

        let stepsCount = try await sumofStepsQuery.result(for: healthStore)

        guard let startDate = startDate else { return }

        print(
            "Fetched step data from \(startDate.formatted(date: .abbreviated, time: .complete)) to \(endDate.formatted(date: .abbreviated, time: .complete))."
        )

        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let healthKitStep = HealthKitStep(count: Int(count ?? -1), date: statistics.startDate)

            if healthKitStep.date != endDate {
                self.healthKitSteps.append(healthKitStep)
            }
        }

    }

    func requestAuthorization() async {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let healthTypes: Set = [stepType]
        guard let healthStore = self.healthStore else { return }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
        } catch {
            print("error fetching health data")
        }
    }
}

struct HealthKitStep {
    let count: Int
    let date: Date
}

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}
