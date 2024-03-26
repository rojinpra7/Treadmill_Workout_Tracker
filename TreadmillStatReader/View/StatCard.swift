//
//  StatCard.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/25/24.
//

import SwiftUI

struct StatCard<T:Hashable, Unit: MeasurementUnit>: View {
    var statName: String
    @Binding var statValue: T
    @Binding var unit: Unit
    @State private var selectedDate = Calendar.current.startOfDay(for: .now)
    @State private var isShowingPopover = false

    var body: some View {
        HStack {
            Text(statName)
            switch statName{
            case "Calories":
                TextField("", value: $statValue, formatter: NumberFormatter()).textFieldStyle(.roundedBorder)
                Picker("Calories", selection: $unit) {
                    Text("Cal")
                }.pickerStyle(.segmented)
            case "Duration":
                Button("\(formatTimeInterval(statValue))") {
                    self.isShowingPopover = true
                }
                .buttonStyle(.bordered)
                .onChange(of: selectedDate) {
                    statValue =  selectedDate.timeIntervalSinceReferenceDate - Calendar.current.startOfDay(for: .now).timeIntervalSinceReferenceDate as! T
                }
                .popover(isPresented: $isShowingPopover) {
                    DatePickerWrapper(selectedDate: $selectedDate)
                        .padding()
                        .frame(width: 180, height: 150)
                        .presentationCompactAdaptation(.popover)
                }
                Picker("Time", selection: $unit) {
                    Text("hh:mm:ss")
                }.pickerStyle(.segmented)
            case "Distance":
                TextField("", value: $statValue, formatter: .distanceFormatter).textFieldStyle(.roundedBorder)
                Picker("Distance", selection: $unit) {
                    Text("mi").tag(DistanceUnit.miles)
                    Text("km").tag(DistanceUnit.kilometer)
                }.pickerStyle(.segmented)
            case "Speed":
                TextField("", value: $statValue, formatter: .distanceFormatter).textFieldStyle(.roundedBorder)
                Picker("Speed", selection: $unit) {
                    Text("mph").tag(SpeedUnit.mph)
                    Text("kph").tag(SpeedUnit.kmph)
                }.pickerStyle(.segmented)
            default:
                Text("Stat not found!")
            }
        }
    }
    
    func formatTimeInterval<V>(_ timeInterval: V) -> String {
        // Assuming V is TimeInterval, you can convert it to a TimeInterval and then format it
        if let timeInterval = timeInterval as? TimeInterval {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) % 3600 / 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return "" // Return empty string if the input is not a valid time interval
        }
    }
}

//#Preview {
//    StatCard()
//}
