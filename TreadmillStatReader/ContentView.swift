//
//  ContentView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/13/24.
//

import SwiftUI

struct ContentView: View {
    
    // View statcard needs statname, statvalue, and unit
    @ObservedObject var viewModel: StatViewModel
    @State var confirmAlert = false
    var body: some View {
        VStack {
            Text("Congratuations! You have reached your treadmill running goals for today. Confirm your stat and add it your Apple health to keep track of your fitness.")
            StatCard(statName: "Calories", statValue: $viewModel.model.calories.0, unit: $viewModel.model.calories.1)
            StatCard(statName: "Distance", statValue: $viewModel.model.distance.0, unit: $viewModel.model.distance.1)
            StatCard(statName: "Time", statValue: $viewModel.model.time.0, unit: $viewModel.model.time.1)
            StatCard(statName: "Speed", statValue: $viewModel.model.speed.0, unit: $viewModel.model.speed.1)
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
    }
}

struct StatCard<T:Hashable>: View {
    
    var statName: String
    @Binding var statValue: String
    @Binding var unit: T

    var body: some View {
        HStack {
            Text(statName)
            TextField(statValue, text: $statValue).textFieldStyle(.roundedBorder)
            
            switch statName{
            case "Calories":
                Picker("Dis", selection: $unit) {
                    Text("Cal").tag(DistanceUnit.miles)
                }.pickerStyle(.segmented)
            case "Time":
                Picker("Dis", selection: $unit) {
                    Text("hh:mm:ss").tag(DistanceUnit.miles)
                }.pickerStyle(.segmented)
            case "Distance":
                Picker("Dis", selection: $unit) {
                    Text("mi").tag(DistanceUnit.miles)
                    Text("km").tag(DistanceUnit.kilometer)
                }.pickerStyle(.segmented)
            case "Speed":
                Picker("Dis", selection: $unit) {
                    Text("mph").tag(SpeedUnit.mph)
                    Text("kph").tag(SpeedUnit.kmph)
                }.pickerStyle(.segmented)
            default:
                Picker("Dis", selection: $unit) {
                    Text("mph").tag(SpeedUnit.mph)
                    Text("kph").tag(SpeedUnit.kmph)
                }.pickerStyle(.segmented)
            }
            
        }
    }
}

enum HealthData: String, CaseIterable, Identifiable {
    case Calories
    case Distance
    case Time
    case Speed
    
    var id: Self {self}
}

protocol MeasurementUnit {
    
}

enum DistanceUnit: String, CaseIterable, Identifiable, MeasurementUnit {
    case miles, kilometer
    var id: Self {self}
}

enum SpeedUnit: String, CaseIterable, Identifiable, MeasurementUnit {
    case mph, kmph
    var id: Self {self}
}

#Preview {
    ContentView(viewModel: StatViewModel())
}
