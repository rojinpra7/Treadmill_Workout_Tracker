//
//  MeasurementUnit.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/25/24.
//
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
