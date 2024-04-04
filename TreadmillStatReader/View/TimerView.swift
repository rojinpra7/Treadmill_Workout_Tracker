//
//  TimerView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/3/24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: StatViewModel
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeElapsed: TimeInterval = 0
    @State var paused = false
    //var timer: AnyPublisher<Date, Never>
    var body: some View {
        let hour = Int(timeElapsed / 3600)
        let minute = Int(timeElapsed.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int(timeElapsed.truncatingRemainder(dividingBy: 60))
        
        if (timeElapsed / 3600 >= 1 ) {
            Text("\(String(format: "%02d:%02d:%02d", hour, minute, second))")
                .font(.custom("Avenir-HeavyOblique", size: 50)).fontWeight(.heavy)
                .onReceive(timer) { _ in
                    timeElapsed += 1
                    print("\(timeElapsed) \(hour) \(minute) \(second)")
                        }
        }
        else {
            Text("\(String(format: "%02d:%02d", minute, second))")
                .font(.custom("Avenir-HeavyOblique", size: 50)).fontWeight(.heavy)
                        .onReceive(timer) { _ in
                            timeElapsed += 1
                            print("\(timeElapsed) \(hour) \(minute) \(second))")
                        }
        }
        
        HStack {
            Button("", systemImage: paused ? "play.circle.fill" :"pause.circle.fill") {
                
                paused.toggle()
                if paused {
                    timer.upstream.connect().cancel()
                    print("Workout is paused!")
                    print("Duration: \(viewModel.duration.wrappedValue)")
                } else {
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    print("Workout resumed!")
                }
            }
                .font(.system(size: 80))
                .foregroundStyle(.black)
                .frame(alignment: .center)
                .contentTransition(.symbolEffect)
            
            if paused {
                Button("", systemImage: "stop.circle.fill") {
                    viewModel.duration.wrappedValue = timeElapsed
                    print("Total workout duration: \(viewModel.duration.wrappedValue)")
                }.font(.system(size: 80)).foregroundStyle(.black).frame(alignment: .center)
                    //.offset(x: -UIScreen.main.bounds.width / 2)
                    //.animation(.easeInOut)
            }
        }
    }
}

//#Preview {
//    TimerView(viewModel: StatViewModel)
//}
