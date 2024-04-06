//
//  HealthStoreSingleton.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/5/24.
//

import Foundation
import HealthKit

class HealthStoreSingleton {
    static let shared = HealthStoreSingleton()
    
    private init() {}
    
    lazy var healthStore: HKHealthStore =  {
        return HKHealthStore()
    }()
    
}
