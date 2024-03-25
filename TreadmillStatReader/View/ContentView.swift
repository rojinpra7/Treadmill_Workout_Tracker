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

struct DatePickerWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        datePicker.date = selectedDate
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate)
    }
    
    // Coordinator class to handle target action
    class Coordinator: NSObject {
        @Binding var selectedDate: Date
        
        init(selectedDate: Binding<Date>) {
            _selectedDate = selectedDate
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            selectedDate = sender.date
        }
    }
}

struct StatCard<T:Hashable, Unit: MeasurementUnit>: View {
    var statName: String
    @Binding var statValue: T
    @Binding var unit: Unit
    @State private var selectedDate = Calendar.current.startOfDay(for: .now)
    @State private var isShowingPopover = false
    
    
    var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }
    
    var durationFormatter: DateComponentsFormatter{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        
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
                Button("\(durationFormatter.string(from: selectedDate.timeIntervalSinceReferenceDate - Calendar.current.startOfDay(for: .now).timeIntervalSinceReferenceDate)! )") {
                    self.isShowingPopover = true
                }.buttonStyle(.bordered)
                .popover(isPresented: $isShowingPopover) {
                    DatePickerWrapper(selectedDate: $selectedDate)
                        .padding()
                        .frame(width: 180, height: 150)
                        .presentationCompactAdaptation(.popover)
                }
                //TextField("", value: $statValue, formatter: timeFormatter).textFieldStyle(.roundedBorder)
                Picker("Time", selection: $unit) {
                    Text("hh:mm:ss")
                }.pickerStyle(.segmented)
            case "Distance":
                TextField("", value: $statValue, formatter: distanceFormatter).textFieldStyle(.roundedBorder)
                Picker("Distance", selection: $unit) {
                    Text("mi").tag(DistanceUnit.miles)
                    Text("km").tag(DistanceUnit.kilometer)
                }.pickerStyle(.segmented)
            case "Speed":
                TextField("", value: $statValue, formatter: distanceFormatter).textFieldStyle(.roundedBorder)
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
