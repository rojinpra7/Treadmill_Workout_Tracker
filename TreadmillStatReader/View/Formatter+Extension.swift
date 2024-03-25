//
//  Formatter+Extension.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/25/24.
//

import Foundation

extension Formatter {
    
    static var distanceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }
    
    static var durationFormatter: DateComponentsFormatter{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        
        return formatter
    }
    
}
