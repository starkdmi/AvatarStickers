//
//  Header.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

struct Header: View {
    var date: Date
    var index: Int
    @State private var isSheetShowing = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 60)
            .foregroundColor(Color.night)
            .opacity(0.9)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(LinearGradient(gradient: Gradient(colors: [.love, .fire]), startPoint: .topTrailing, endPoint: .bottomLeading), lineWidth: 3)
                    .overlay(
                        HStack {
                            if index == 0 {
                                Spacer().frame(width: 64)
                                Spacer()
                            }
                            
                            Text(StickersGalleryView.formatDate(date))
                                .font(Font.system(size: 28).weight(.heavy))
                                .gradientForeground(colors: [.fire, .love])
                                .multilineTextAlignment(.center)
                            
                            if index == 0 {
                                Spacer()
                                Button {
                                    isSheetShowing.toggle()
                                } label: {
                                    LinearGradient(gradient: Gradient(colors: [Color(red: 253/255, green: 66/255, blue: 39/255), .love]), startPoint: .leading, endPoint: .trailing)
                                        .mask (
                                            Label("settings", systemImage: "ellipsis")
                                                .labelStyle(IconOnlyLabelStyle())
                                                .font(Font.system(size: 28).weight(.bold))
                                                .foregroundColor(.love)
                                                .rotationEffect(.degrees(-90))
                                            )
                                        .padding()
                                        .frame(width: 64)
                                }
                            }
                        }
                        .sheet(isPresented: $isSheetShowing) {
                            SettingsView().preferredColorScheme(.dark)
                        }
                    )
            )
            .padding(.vertical, 8)
            .padding(.top, index == 0 ? 6 : 0)
                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 0 : 4)
        
    }
}
