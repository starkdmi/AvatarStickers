//
//  TGWAToggleStyle.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct TGWAToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Button {
                configuration.isOn = false
            } label: {
                Text("Telegram")
                    .gradientForeground(colors: [.grass, .sky])
                    .opacity(configuration.isOn ? 0.36 : 1.0)
            }
            Button {
                configuration.isOn.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.fire, .love]), startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(Color.night)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
            Button {
                configuration.isOn = true
            } label: {
                Text("WhatsApp")
                    .foregroundColor(.grass)
                    .opacity(configuration.isOn ? 1.0 : 0.36)
            }
        }
        .font(.system(size: 24).weight(.bold))
    }
}
