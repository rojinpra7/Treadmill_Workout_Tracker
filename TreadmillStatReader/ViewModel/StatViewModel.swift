//
//  StatViewModel.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/14/24.
//

import Foundation
import SwiftUI

class StatViewModel: ObservableObject {
    @Published private var model = StatModel()
    @Published var distanceUnit: DistanceUnit = .miles
    @Published var speedUnit: SpeedUnit = .mph
    
    var startDate: Binding<Date> {
        Binding(get: {self.model.startDate}, set: {newValue in self.model.startDate = newValue})
    }
    
    var calories: Binding<Int> {
        Binding(get: {self.model.calories}, set: {newValue in self.model.calories = newValue})
    }
    
    var distance: Binding<Double> {
        Binding(get: {
            if (self.distanceUnit == .kilometer) { return self.model.distance * 1.61 }
            return self.model.distance
            },
            set: { newValue in
                if (self.distanceUnit == .kilometer) {
                    self.model.distance = newValue * 0.6214
                }
                else {
                    self.model.distance = newValue
                }
            })
    }
                
    var duration: Binding<TimeInterval> {
        Binding(get: {self.model.duration}, set: {newValue in self.model.duration = newValue})
    }
    
    var speed: Binding<Double> {
        Binding(get: {
            if (self.speedUnit == .kmph) { return self.model.speed * 1.61 }
            return self.model.speed
            },
            set: { newValue in
                if (self.speedUnit == .kmph) {
                    self.model.speed = newValue * 0.6214
                }
                else {
                    self.model.speed = newValue
                }
            })
    }
    
    func printStat() {
        print("Start Date: \(startDate.wrappedValue)")
        print("Calories Burned: \(calories.wrappedValue)")
        print("Distance Covered: \(model.distance)")
        print("Workout Time: \(duration.wrappedValue)")
        print("Speed: \(model.speed)")
    }
}
