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
                Button("\(Formatter.durationFormatter.string(from: selectedDate.timeIntervalSinceReferenceDate - Calendar.current.startOfDay(for: .now).timeIntervalSinceReferenceDate)! )") {
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
}

//#Preview {
//    StatCard()
//}
