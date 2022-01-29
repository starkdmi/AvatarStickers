//
//  iCloudToggleStyle.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct iCloudToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text("icloud")
                .font(.system(size: 24).weight(.bold))
                .gradientForeground(colors: [.fire, .love])
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
            }) {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.fire, .love]), startPoint: .leading, endPoint: .trailing)
                    )
                    .opacity(configuration.isOn ? 1.0 : 0.75)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(Color.night)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
        .font(.title)
    }
}
