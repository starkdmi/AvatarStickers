//
//  AddButtonStyle.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 60)
            .foregroundColor(.clear)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    .fire,
                    .love
                ]), startPoint: .bottomLeading, endPoint: .topTrailing)
                    .mask(RoundedRectangle(cornerRadius: 8).frame(height: 60))
                    .opacity(configuration.isPressed ? 0.76 : 0.9)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 3)
                    .foregroundColor(Color.night)
                    .overlay(
                        Label("add", systemImage: "plus")
                            .font(Font.system(size: 28).weight(.heavy))
                            .foregroundColor(configuration.isPressed ? Color.night : Color.night)
                            .multilineTextAlignment(.center)
                            .padding()
                        )
            )
            .padding()
    }
}
