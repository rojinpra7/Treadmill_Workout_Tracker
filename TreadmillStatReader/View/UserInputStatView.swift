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
     
    let healthStore = HealthStoreSingleton.shared.healthStore
    
    var body: some View {
        VStack {
            Spacer()
            Text("Manually add your workout stat and sync with your Apple health to keep track of your fitness.")
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
                    let runningWorkoutBuilder = RunningWorkoutBuilder(distance: viewModel.distance.wrappedValue, calories: viewModel.calories.wrappedValue, speed: viewModel.speed.wrappedValue, startDate: viewModel.startDate.wrappedValue, endDate: viewModel.endDate)
                    runningWorkoutBuilder.manualWorkoutEntry()
                    
                } catch {
                    fatalError("*** An unexpected error occured while requesting authorization: \(error.localizedDescription) ***")
                }
                
            }), secondaryButton: .default(Text("No"), action: {}))
        })
        .onChange(of: viewModel.distanceUnit) {
            viewModel.printStat()
        }
        .healthDataAccessRequest(store: healthStore, shareTypes: RunningWorkoutBuilder.allTypes, readTypes: RunningWorkoutBuilder.allTypes, trigger: hkDataRequest) { result in
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
