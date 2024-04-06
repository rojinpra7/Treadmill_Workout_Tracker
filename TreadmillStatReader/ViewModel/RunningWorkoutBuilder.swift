//
//  HealthStore.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/5/24.
//

import Foundation
import HealthKit

class RunningWorkoutBuilder {
    let healthStore: HKHealthStore
    let runningWorkoutBuilder: HKWorkoutBuilder
    let distanceSample: HKQuantitySample
    let calorieSample: HKQuantitySample
    let speedSample: HKQuantitySample
    let startDate: Date
    let endDate: Date
    
    
    init(distance: Double, calories: Double, speed: Double, startDate: Date, endDate: Date ) {
        healthStore = HealthStoreSingleton.shared.healthStore
        runningWorkoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: RunningWorkoutBuilder.runningConfiguration , device: .local())
        //let startDate = Calendar.current.date(bySettingHour: 14, minute: 35, second: 0, of: Date())!
        //let endDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
        let distanceType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let distanceQuantity = HKQuantity(unit: .mile(), doubleValue: distance)
        self.distanceSample = HKQuantitySample(type: distanceType, quantity: distanceQuantity, start: startDate, end: endDate)
        
        let calorieType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
        let energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: calories)
        self.calorieSample = HKQuantitySample(type: calorieType, quantity: energyBurned, start: startDate, end: endDate)
        
        let speedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
        let speedQuantity = HKQuantity(unit: .mile().unitDivided(by: .hour()), doubleValue: speed)
        self.speedSample = HKQuantitySample(type: speedType, quantity: speedQuantity, start: startDate, end: endDate)
        
        self.startDate = startDate
        self.endDate = endDate
    }
    
    //func running
    
    func manualWorkoutEntry() {
        runningWorkoutBuilder.beginCollection(withStart: self.startDate) { success, error in
            if success {
                print("Workout has begun at \(self.startDate)")
            } else {
                print("Couldn't begin the workout: \(String(describing: error))")
            }
        }
        
        runningWorkoutBuilder.add([distanceSample, calorieSample]) { success, error in
            if success {
                print("\(self.distanceSample) saved to apple health")
                print("\(self.calorieSample) saved to apple health")
                //print("\(speedSample) saved to apple health")
            } else {
                print("Couldn't add the sample!")
            }
        }
        runningWorkoutBuilder.endCollection(withEnd: self.endDate) { success, error in
            if success {
                print("Workout has ended at \(self.endDate)")
            } else {
                print("Couldn't stop the workout: \(String(describing: error))")
            }
        }
        runningWorkoutBuilder.finishWorkout() { workout, error in
            if let workout = workout {
                print("\(workout) is saved.")
            } else {
                print("Unable to save the workout.")
            }
        }
    }
    
    static let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.runningSpeed),
    ]

    static var runningConfiguration : HKWorkoutConfiguration {
        let runningConfiguration = HKWorkoutConfiguration()
        runningConfiguration.activityType = .running
        runningConfiguration.locationType = .outdoor
        return runningConfiguration
    }
    
}
