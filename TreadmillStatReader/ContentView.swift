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
    @State var caloriesUnit: CaloriesUnit = .cal
    @State var timeUnit: TimeUnit = .hhmmss
    @State var confirmAlert = false
    var body: some View {
        VStack {
            Text("Congratuations! You have reached your treadmill running goals for today. Confirm your stat and add it your Apple health to keep track of your fitness.")
            StatCard(statName: "Calories", statValue: viewModel.calories, unit: $caloriesUnit)
            StatCard(statName: "Distance", statValue: viewModel.distance, unit: $viewModel.distanceUnit)
            StatCard(statName: "Time", statValue: viewModel.time, unit: $viewModel.distanceUnit)
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

struct StatCard<T:Hashable, Unit: MeasurementUnit>: View {
    var statName: String
    @Binding var statValue: T
    @Binding var unit: Unit
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        HStack {
            Text(statName)
            
            switch statName{
            case "Calories":
                TextField("", value: $statValue, formatter: NumberFormatter()).textFieldStyle(.roundedBorder)
                Picker("Calories", selection: $unit) {
                    Text("Cal")
                }.pickerStyle(.segmented)
            case "Time":
                TextField("", value: $statValue, formatter: formatter).textFieldStyle(.roundedBorder)
                Picker("Time", selection: $unit) {
                    Text("hh:mm:ss")
                }.pickerStyle(.segmented)
            case "Distance":
                TextField("", value: $statValue, formatter: formatter).textFieldStyle(.roundedBorder)
                Picker("Distance", selection: $unit) {
                    Text("mi").tag(DistanceUnit.miles)
                    Text("km").tag(DistanceUnit.kilometer)
                }.pickerStyle(.segmented)
            case "Speed":
                TextField("", value: $statValue, formatter: formatter).textFieldStyle(.roundedBorder)
                Picker("Speed", selection: $unit) {
                    Text("mph").tag(SpeedUnit.mph)
                    Text("kph").tag(SpeedUnit.kmph)
                }.pickerStyle(.segmented)
            default:
                Text("Stat not found!")
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

protocol MeasurementUnit : Hashable {
    
}

enum CaloriesUnit: MeasurementUnit {
    case cal
}

enum DistanceUnit: String, CaseIterable, Identifiable, MeasurementUnit {
    case miles, kilometer
    var id: Self {self}
    
    var unit: String {
        switch self {
        case .miles:
            return "mi"
        case .kilometer:
            return "km"
        }
    }
}

enum TimeUnit: MeasurementUnit {
    case hhmmss
}

enum SpeedUnit: String, CaseIterable, Identifiable, MeasurementUnit {
    case mph, kmph
    var id: Self {self}
    
    var unit: String {
        switch self {
        case .mph:
            return "mph"
        case .kmph:
            return "kmph"
        }
    }
}

#Preview {
    ContentView(viewModel: StatViewModel())
}
