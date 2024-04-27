//
//  NavigationBarView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/26/24.
//

import SwiftUI

struct NavigationBarView: View {
    @State private var selectedTab = "Home"
    var body: some View {
        TabView(selection: $selectedTab) {
            UserInputStatView(viewModel: StatViewModel())
                .background(.cyan)
                .tabItem {
                    NavigationBarItem(image: "Home", textLabel: "Home", selectedTab: $selectedTab)
                }
                .tag("Home")
            TrainingView()
                .tabItem {
                    NavigationBarItem(image: "Training", textLabel: "Training", selectedTab: $selectedTab)
                }
                .tag("Training")
            RunningSessionView()
                .tabItem {
                    NavigationBarItem(image: "Running", textLabel: "Running", selectedTab: $selectedTab)
                }
                .tag("Running")
            ClubView()
                .tabItem {
                    NavigationBarItem(image: "Club", textLabel: "Club", selectedTab: $selectedTab)
                }
                .tag("Club")
            ProgressView()
                .tabItem {
                    NavigationBarItem(image: "Progress", textLabel: "Progress", selectedTab: $selectedTab)
                }
                .tag("Progress")
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
  }
}

struct NavigationBarItem: View {
    let image: String
    let textLabel: String
    @Binding var selectedTab: String
    var body: some View {
        Button(action: {
            selectedTab = textLabel
        }) {
            VStack(spacing: 4) {
              Image("\(image)")
                .renderingMode(.template)
                .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                .frame(height: 25)
              Text("\(textLabel)")
                .font(Font.custom("Roboto", size: 12).weight(.medium))
                .tracking(0.50)
            }
            .foregroundColor(selectedTab == textLabel ? .black : Color(red: 0.29, green: 0.27, blue: 0.31))
        }
    }
}

#Preview {
    NavigationBarView()
}
