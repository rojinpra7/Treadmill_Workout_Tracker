//
//  NavigationBarView.swift
//  TreadmillStatReader
//
//  Created by Rojin Prajapati on 4/26/24.
//

import SwiftUI

struct NavigationBarView: View {
  var body: some View {
      HStack(alignment: .top, spacing: 8) {
          NavigationBarItem(image: "Home", textLabel: "Home")
          NavigationBarItem(image: "Training", textLabel: "Training")
          NavigationBarItem(image: "Running", textLabel: "Running")
          NavigationBarItem(image: "Club", textLabel: "Club")
          NavigationBarItem(image: "Progress", textLabel: "Progress")
      }
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
        //.frame(width: 412, height: 80)
        .background(Color(red: 0.95, green: 0.93, blue: 0.97));
  }
}

struct NavigationBarItem: View {
    let image: String
    let textLabel: String
    var body: some View {
        VStack(spacing: 4) {
          Image("\(image)")
            .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
          Text("\(textLabel)")
            .font(Font.custom("Roboto", size: 12).weight(.semibold))
            .tracking(0.50)
            .foregroundColor(Color(red: 0.29, green: 0.27, blue: 0.31))
        }
        .padding(EdgeInsets(top: 12, leading: 0, bottom: 16, trailing: 0))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationBarView()
}
