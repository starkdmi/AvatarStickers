//
//  IntroView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Lottie

struct IntroView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .padding(.leading, 54)
                    .padding(.trailing, 54)
                    .shadow(color: .darkGreen, radius: 1, x: 2, y: 1)
                    .offset(y: -10)
                    .overlay(
                        VStack {
                            Text("Avatar")
                            Text("Stickers")
                        }
                        .font(.system(size: 64).weight(.heavy))
                        .gradientForeground(colors: [Color(red: 35/255, green: 43/255, blue: 43/255), Color.night])
                    )
                    .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 2.0 : 1.0)
                    
                if let image = "😋".image(fontSize: 60) {
                    Image(uiImage: image)
                        .rotationEffect(.degrees(-15))
                        .offset(x: UIDevice.current.userInterfaceIdiom == .pad ? -152 : -104, y: 148)
                        .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0)
                }
                
                if let image = "😘".image(fontSize: 68) {
                    Image(uiImage: image)
                        .rotationEffect(.degrees(-30))
                        .offset(x: UIDevice.current.userInterfaceIdiom == .pad ? -136 : -112, y: -144)
                        .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0)
                }
                
                if let image = "🐵".image(fontSize: 86) {
                    Image(uiImage: image)
                        .rotationEffect(.degrees(30))
                        .offset(x: UIDevice.current.userInterfaceIdiom == .pad ? 146 : 104, y: -156)
                        .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0)
                }
            }
            
            Button {
                UserDefaults.standard.setValue(true, forKey: "useAnimations")
                UserDefaults.standard.setValue(false, forKey: "isFirstRun")
                
                if UIApplication.shared.canOpenURL(URL(string: "tg://")!) {
                    // Telegram by default
                    // UserDefaults.standard.setValue(false, forKey: "isWhatsApp")
                } else if UIDevice.current.userInterfaceIdiom == .phone && UIApplication.shared.canOpenURL(URL(string: "https://wa.me/+79951213460")!) {
                    // WhatsApp
                    UserDefaults.standard.setValue(true, forKey: "isWhatsApp")
                }
            } label: {
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color.night)
                    .frame(width: 260, height: 54)
                    .overlay(
                        Text("start")
                            .font(.system(size: 22).weight(.bold))
                            .gradientForeground(colors: [.sea, .grass])
                    )
                    .padding(.bottom, 30)
                    .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 1.5 : 1.0)
            }.buttonStyle(PlainButtonStyle())
            
                        
            HStack {
                if let animation = Lottie.Animation.named("girl") {
                    LottieView(animation: animation)
                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 140, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 140)
                        .aspectRatio(contentMode: .fit)
                        .offset(x: -20)
                }
                if let animation = Lottie.Animation.named("boy") {
                    LottieView(animation: animation)
                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 140, height: UIDevice.current.userInterfaceIdiom == .pad ? 240 : 140)
                        .aspectRatio(contentMode: .fit)
                        .offset(x: -70)
                }
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            LinearGradient(gradient: Gradient(colors: [ .sea, .grass]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IntroView()
            
            IntroView()
                .previewDevice("iPad mini (6th generation)")
        }
    }
}
