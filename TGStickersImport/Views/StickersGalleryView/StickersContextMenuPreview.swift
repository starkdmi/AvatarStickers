//
//  StickersContextMenuPreview.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct StickersContextMenuPreview: View {
    let id: Date
    let size: CGSize
    let columns: Int
    let stickers: [Sticker]
    let isTelegram: Bool?
    @AppStorage("useAnimations") var useAnimations: Bool = true
            
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                .grass,
                .sea
            ]), startPoint: .bottomLeading, endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all)
            
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.night, lineWidth: 7.0)
                .overlay(
                    LazyVGrid(columns: (1...columns).map { _ in GridItem(.adaptive(minimum: 100)) }, spacing: 12) {
                        ForEach(stickers, id: \.self) { sticker in
                            if let data = sticker.animation {
                                Group {
                                    if isTelegram == false {
                                        AnimatedImage(data: data)
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                    } else {
                                        LazyLottieView(data: data)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.all, 12)
                )
                .frame(width: size.width, height: size.height)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors:
                                [.grass, .sea]
                            ), startPoint: .bottomLeading, endPoint: .topTrailing)
                        )
                )
        }
        .id(id)
    }
}
