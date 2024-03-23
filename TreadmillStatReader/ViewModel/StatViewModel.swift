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
                
    var time: Binding<TimeInterval> {
        Binding(get: {self.model.time}, set: {newValue in self.model.time = newValue})
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
        print(calories.wrappedValue)
        print(model.distance)
        print(time.wrappedValue)
        print(model.speed)
    }
}
