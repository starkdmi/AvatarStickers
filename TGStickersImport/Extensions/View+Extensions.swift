//
//  View+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

extension View {
    func gradientForeground(colors: [SwiftUI.Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)).mask(self)
    }
}
