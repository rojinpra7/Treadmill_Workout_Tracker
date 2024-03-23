//
//  TreadmillStatReaderApp.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 3/13/24.
//

import SwiftUI

@main
struct TreadmillStatReaderApp: App {
    @StateObject private var viewModel = StatViewModel()
    var body: some Scene {
        WindowGroup {
            LaunchScreenView(viewModel: viewModel)
        }
    }
}
