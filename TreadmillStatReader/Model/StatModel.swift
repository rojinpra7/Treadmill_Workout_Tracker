//
//  StatModel.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/14/24.
//

import Foundation

struct StatModel {
    var calories: (String, String) = ("", "Cal")
    var distance: (String, DistanceUnit) = ("", .miles)
    var time: (String, String) = ("", "hr:min:sec")
    var speed: (String, SpeedUnit) = ("", .mph)
    
    
    
//    mutating func updateCalories(caloriesValue: String) {
//        calories.1 = caloriesValue
//    }
//    
//    mutating func updateDistance(distanceValue: String) {
//        distance.1 = distanceValue
//    }
//    
//    mutating func updateTime(timeValue: String) {
//        time.1 = timeValue
//    }
//    
//    mutating func updateSpeed(speedValue: String) {
//        speed.1 = speedValue
//    }
//    
}
