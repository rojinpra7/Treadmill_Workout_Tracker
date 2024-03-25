//
//  DatePickerWrapper.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/25/24.
//

import SwiftUI

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
