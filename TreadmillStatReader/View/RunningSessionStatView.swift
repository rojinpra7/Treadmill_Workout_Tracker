//
//  RunningSessionStatView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/29/24.
//

import SwiftUI

struct RunningSessionStatView: View {
    @ObservedObject var viewModel: StatViewModel
    @State var pause = false
    var body: some View {
        VStack(spacing:.zero) {
            Spacer()
            Text("\(String(format: "%.2f", viewModel.distance.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 80)).fontWeight(.heavy)
            Text("miles").font(.custom("Avenir-HeavyOblique", size: 25))
            Spacer()
            HStack {
                VStack {
                    Label("", systemImage: "gauge.with.dots.needle.bottom.50percent").font(.title)
                    Text("\(String(format: "%.2f", viewModel.speed.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
                Spacer()
                VStack {
                    Label("", systemImage: "heart").font(.title)
                    Text("\(String(format: "%.2f", viewModel.calories.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
                Spacer()
                VStack {
                    Label("", systemImage: "flame.fill").font(.title)
                    Text("\(String(format: "%.2f", viewModel.calories.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 25)).fontWeight(.heavy)
                }
            }.padding(50)
            Spacer()
            VStack {
                Label("", systemImage: "timer").font(.largeTitle)
                Text("\(String(format: "%.2f", viewModel .duration.wrappedValue))").font(.custom("Avenir-HeavyOblique", size: 50)).fontWeight(.heavy)
            }
            Spacer()
            Button("", systemImage: "pause.circle.fill") {
                pause.toggle()
            }.font(.system(size: 80)).foregroundStyle(.black).frame(alignment: .center)
            Button("Connect Music") {
                
            }
            .frame(width: 315, height: 59)
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            
        }
        .padding(.bottom, 1)
        .background(.green)
        .onChange(of: pause) {
            
        }
        
        //Text("Distance: 5mi").font(.title).fontDesign(.monospaced)
    }
}


#Preview {
    RunningSessionStatView(viewModel: StatViewModel())
}
