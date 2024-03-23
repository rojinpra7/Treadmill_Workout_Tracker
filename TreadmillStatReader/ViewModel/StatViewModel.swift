//
//  StatViewModel.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/14/24.
//

import Foundation

class StatViewModel: ObservableObject {
    @Published var model = StatModel()
    
    var calories: (String, String) {
        return model.calories
    }
    
    var distance: (String, DistanceUnit) {
        return model.distance
    }
    
    var time: (String, String) {
        return model.time
    }
    
    var speed: (String, SpeedUnit) {
        return model.speed
    }
    
    func printStat() {
        print(calories)
        print(distance)
        print(time)
        print(speed)
    }
    
//    func updateCalor(_ newValue: String) {
//       model.calories = newValue
//    }
    
}
