//
//  ExportButtonStyle.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct ExportButtonStyle: ButtonStyle {
    var disabled: Bool
    var loading: Bool
    @Binding var processing: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 60)
            .fill(Color.night)
            .frame(width: 260, height: 54)
            .animation(nil)
            .overlay(
                Group {
                    if loading && processing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.4)))
                    } else {
                        Text("done")
                            .font(.system(size: 22).weight(.heavy))
                            .gradientForeground(colors: [.fire.opacity(0.9), Color(red: 255/255, green: 83/255, blue: 83/255)])
                            .opacity(configuration.isPressed ? 0.86 : 1.0)
                    }
                }
            )
            .padding(.bottom, 20)
    }
}
