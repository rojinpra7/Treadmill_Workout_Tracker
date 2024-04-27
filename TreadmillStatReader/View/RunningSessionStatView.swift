//
//  RunningSessionStatView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/29/24.
//

import SwiftUI
import Combine
import CoreLocation
import HealthKit

struct RunningSessionStatView: View {
    @StateObject var locationDataManager = LocationDataManager()
    @ObservedObject var viewModel: StatViewModel
    @State var paused = false
    //let runningWorkoutBuilder : RunningWorkoutBuilder
    //let session: HKWorkoutSession
    //@State private var timeElapsed: TimeInterval = 0
    //@State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing:.zero) {
            Spacer()
            
            Text("\(String(format: "%.2f", locationDataManager.distanceRunned))").font(.custom("Avenir-HeavyOblique", size: 80)).fontWeight(.heavy)
            Text("miles").font(.custom("Avenir-HeavyOblique", size: 25))
            Spacer()
            HStack {
                VStack {
                    Label("", systemImage: "gauge.with.dots.needle.bottom.0percent").font(.title)
                    let paceMinutes = Int(locationDataManager.currentPace)
                    let paceSeconds = Int((locationDataManager.currentPace - Double(paceMinutes)) * 60)
                    Text("\(String(format: "%02d:%02d", paceMinutes, paceSeconds))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
//                VStack {
//                    Label("", systemImage: "gauge.with.dots.needle.bottom.50percent").font(.title)
//                    Text("\(String(format: "%.2f", viewModel.speed.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
//                }
                VStack {
                    Label("", systemImage: "heart").font(.title)
                    Text("\(String(format: "%.2f", viewModel.calories.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
                VStack {
                    Label("", systemImage: "flame.fill").font(.title)
                    Text("\(String(format: "%.2f", viewModel.calories.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
            }.padding(50)
            
            switch locationDataManager.locationDataManager.authorizationStatus {
            case .authorizedWhenInUse:
                Text("Latitude: \(locationDataManager.locationDataManager.location?.coordinate.latitude.description ?? "Error Loading")")
                Text("Longitude: \(locationDataManager.locationDataManager.location?.coordinate.longitude.description ?? "Error Loading")")
            case .denied, .restricted:
                Text("Current location data was restricted or denied")
            case .notDetermined:
                Text("Location not determined")
            default:
                Text("No GPS")
            }
            
            // Circle phase animator
            Circle()
                .frame(width: 500)
                .phaseAnimator([true, false, true, false, true, false]) { content, phase in
                    content
                        .opacity(phase ? 1 : 0.5)
                        .scaleEffect(phase ? 1 : 1.5)
                        .foregroundStyle(phase ? .blue : .red)
                } animation: { phase in
                        .spring.speed(0.5)
                }
            
            Spacer()
        
            Label("", systemImage: "timer").font(.largeTitle)
            TimerView(viewModel: viewModel)
            Spacer()
           
            Button("Connect Music") {
                
            }
            .frame(width: 315, height: 59)
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
        }
        .padding(.bottom, 1)
        .background(.green)
        .onAppear {
            guard HKHealthStore.isHealthDataAvailable() else {
                print("HealthKit is not available on this device.")
                return
            }
//            do {
//               session = try HKWorkoutSession(heal)
//            }
            //runningWorkoutBuilder = RunningWorkoutBuilder(distance: 0.0, calories: 0.0, speed: 0.0, startDate: Date.now, endDate: <#T##Date#>)
            //routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
            
            
            
        }
        
    }
}

#Preview {
    RunningSessionStatView(viewModel: StatViewModel())
}
