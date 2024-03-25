//
//  ContentView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/13/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    // View statcard needs statname, statvalue, and unit
    @ObservedObject var viewModel: StatViewModel
    @State var caloriesUnit: CaloriesUnit = .cal
    @State var timeUnit: TimeUnit = .hhmmss
    @State var confirmAlert = false
    @State var hourSelection: Int = 0
    @State var minuteSelection: Int = 0
    @State var seconds: Int = 0
     
    var body: some View {
        VStack {
            Text("Congratuations! You have reached your treadmill running goals for today. Confirm your stat and add it your Apple health to keep track of your fitness.")
            DatePicker("StartDate", selection: viewModel.startDate)
            StatCard(statName: "Calories", statValue: viewModel.calories, unit: $caloriesUnit)
            StatCard(statName: "Distance", statValue: viewModel.distance, unit: $viewModel.distanceUnit)
            StatCard(statName: "Duration", statValue: viewModel.duration, unit: $viewModel.distanceUnit)
            StatCard(statName: "Speed", statValue: viewModel.speed, unit: $viewModel.speedUnit)
            HStack {
                Button("Confirm", action: {
                    confirmAlert = true
                    viewModel.printStat()
                }).buttonStyle(.bordered)
                Button("Cancel", action: {}).buttonStyle(.bordered)
            }
        }
        .padding()
        .alert(isPresented: $confirmAlert, content: {
            Alert(title: Text("Would you like to sync the data with Apple Health?"), primaryButton: .cancel(Text("Yes"), action: {}), secondaryButton: .default(Text("No"), action: {}))
        })
        .onChange(of: viewModel.distanceUnit) {
            viewModel.printStat()
        }
    }
}

#Preview {
    ContentView(viewModel: StatViewModel())
}
