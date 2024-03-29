//
//  ContentView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/13/24.
//

import SwiftUI
import HealthKitUI

struct UserInputStatView: View {
    // View statcard needs statname, statvalue, and unit
    @ObservedObject var viewModel: StatViewModel
    @State var caloriesUnit: CaloriesUnit = .cal
    @State var timeUnit: TimeUnit = .hhmmss
    @State var confirmAlert = false
    @State var hourSelection: Int = 0
    @State var minuteSelection: Int = 0
    @State var seconds: Int = 0
    @State var hkDataRequest = false
    @State var authenticated = false
     
    let healthStore = HKHealthStore()
    
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.runningSpeed),
    ]

    var runningConfiguration : HKWorkoutConfiguration {
        let runningConfiguration = HKWorkoutConfiguration()
        runningConfiguration.activityType = .running
        runningConfiguration.locationType = .outdoor
        return runningConfiguration
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Congratuations! You have reached your treadmill running goals for today. Confirm your stat and add it your Apple health to keep track of your fitness.")
            DatePicker("StartDate", selection: viewModel.startDate)
            StatCard(statName: "Calories", statValue: viewModel.calories, unit: $caloriesUnit)
            StatCard(statName: "Distance", statValue: viewModel.distance, unit: $viewModel.distanceUnit)
            StatCard(statName: "Duration", statValue: viewModel.duration, unit: $viewModel.distanceUnit)
            StatCard(statName: "Speed", statValue: viewModel.speed, unit: $viewModel.speedUnit)
            HStack {
                Button("Confirm", action: {
                    confirmAlert = true
                }).buttonStyle(.bordered)
                Button("Cancel", action: {}).buttonStyle(.bordered)
            }
            Spacer()
        }
        .padding()
        .alert(isPresented: $confirmAlert, content: {
            Alert(title: Text("Would you like to sync the data with Apple Health?"), primaryButton: .cancel(Text("Yes"), action: {
                viewModel.printStat()
                do {
                    guard HKHealthStore.isHealthDataAvailable() else {
                        print("HealthKit is not available on this device.")
                        return
                    }
                    hkDataRequest = true
                    let run = HKWorkoutBuilder(healthStore: healthStore, configuration: runningConfiguration , device: .local())
                    
                    //let startDate = Calendar.current.date(bySettingHour: 14, minute: 35, second: 0, of: Date())!
                    //let endDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
                    let distanceType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
                    let distanceQuantity = HKQuantity(unit: .mile(), doubleValue: viewModel.distance.wrappedValue
                    )
                    let distanceSample = HKQuantitySample(type: distanceType, quantity: distanceQuantity, start: viewModel.startDate.wrappedValue, end: viewModel.endDate)
                    
                    let calorieType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!
                    let energyBurned = HKQuantity(unit: .kilocalorie(), doubleValue: viewModel.calories.wrappedValue)
                    let calorieSample = HKQuantitySample(type: calorieType, quantity: energyBurned, start: viewModel.startDate.wrappedValue, end: viewModel.endDate)
                    
                    let speedType = HKSampleType.quantityType(forIdentifier: .runningSpeed)!
                    let speedQuantity = HKQuantity(unit: .mile().unitDivided(by: .hour()), doubleValue: viewModel.speed.wrappedValue)
                    let speedSample = HKQuantitySample(type: speedType, quantity: speedQuantity, start: viewModel.startDate.wrappedValue, end: viewModel.endDate)
                    
                    run.beginCollection(withStart: viewModel.startDate.wrappedValue) { success, error in
                        if success {
                            print("Workout has begun at \(viewModel.startDate)")
                        } else {
                            print("Couldn't begin the workout: \(String(describing: error))")
                        }
                    }
                    run.add([distanceSample, calorieSample]) { success, error in
                        if success {
                            print("\(distanceSample) saved to apple health")
                            print("\(calorieSample) saved to apple health")
                            //print("\(speedSample) saved to apple health")
                        } else {
                            print("Couldn't add the sample!")
                        }
                        
                    }
                    run.endCollection(withEnd: viewModel.endDate) { success, error in
                        if success {
                            print("Workout has ended at \(viewModel.endDate)")
                        } else {
                            print("Couldn't stop the workout: \(String(describing: error))")
                        }
                    }
                    run.finishWorkout() { workout, error in
                        if let workout = workout {
                            print("\(workout) is saved.")
                        } else {
                            print("Unable to save the workout.")
                        }
                    }
                } catch {
                    fatalError("*** An unexpected error occured while requesting authorization: \(error.localizedDescription) ***")
                }
                
            }), secondaryButton: .default(Text("No"), action: {}))
        })
        .onChange(of: viewModel.distanceUnit) {
            viewModel.printStat()
        }
        .healthDataAccessRequest(store: healthStore, shareTypes: allTypes, readTypes: allTypes, trigger: hkDataRequest) { result in
            switch result {
            case .success(_):
                authenticated = true
                print("User is authenticated.")
                
            case .failure(let error):
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}

#Preview {
    UserInputStatView(viewModel: StatViewModel())
}
