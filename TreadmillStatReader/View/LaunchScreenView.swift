//
//  LaunchScreenView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/13/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @ObservedObject var viewModel: StatViewModel
    var body: some View {
        NavigationStack{
            VStack {
                Text("Welcome to Treadmill Stat Reader")
                NavigationLink("Let's get started", destination: UserInputStatView(viewModel: viewModel)).navigationBarBackButtonHidden(true)
            }
        }
        
        
    }
}

//#Preview {
//    LaunchScreenView(viewModel: ))
//}
