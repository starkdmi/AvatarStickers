//
//  ExportView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import TelegramStickersImport
import Lottie
import Gzip

struct ExportView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var isTelegram: Bool = true
    var isGallery: Bool = false
    var animatedData: [String: Data] = [:]
    var staticData: [String: UIImage] = [:]
    @Binding var image: UIImage?
    
    @State var exporting: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        if isGallery {
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.image = nil
                        }
                    }
                } label: {
                    Label("mainMenu", systemImage: "chevron.left")
                        .font(.system(size: 24).weight(.heavy))
                        .foregroundColor(Color.night)
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 16)
                    
            if installed && (isTelegram || (isTelegram == false && UIDevice.current.userInterfaceIdiom == .phone)) {
                Text(UIDevice.current.userInterfaceIdiom == .pad ? "exportTitlePad" : "exportTitle")
                    .kerning(UIDevice.current.userInterfaceIdiom == .pad ? 20 : 8)
                    .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 72 : isTelegram ? 52 : 56).weight(.heavy))
                    .gradientForeground(colors: [Color(red: 35/255, green: 43/255, blue: 43/255), Color.night])
                    .multilineTextAlignment(.center)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad || UIScreen.main.bounds.height < 700 ? 20 : 32)
                
                Spacer()

                Circle()
                    .stroke(lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 12 : 10)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 392 : 264)
                    .foregroundColor(isTelegram ? Color.night : .clear)
                    .background(
                        Group {
                            if isTelegram {
                                if let animation = Lottie.Animation.named("telegram") {
                                    LottieView(animation: animation)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .scaleEffect(UIDevice.current.userInterfaceIdiom == .pad ? 3.4 : 2.8)
                                } else {
                                    Image("telegram")
                                        .resizable()
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .scaleEffect(0.8)
                                        .frame(maxWidth: 216)
                                        .offset(x: -8, y: -2)
                                }
                            } else {
                                if let animation = Lottie.Animation.named("whatsapp") {
                                    LottieView(animation: animation)
                                        .aspectRatio(1.0, contentMode: .fit)
                                        .scaleEffect(2.5)
                                }
                            }
                        }
                    )
                    .zIndex(-1)
                    .offset(y: -4)
            } else {
                Spacer()
                Link(destination: URL(string: isTelegram ? "https://apps.apple.com/app/telegram-messenger/id686449807" : "https://apps.apple.com/us/app/whatsapp-messenger/id310633997")!) {
                    Text(isTelegram ? "notInstalled" : "noWhatsApp")
                        .font(Font.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 48 : 38).weight(.heavy))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.night)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                }
            }
            Spacer()
            
            Button {
                if isTelegram {
                    // Telegram Export
                    if installed {
                        exporting = true
                        do {
                            let stickerSet = TelegramStickersImport.StickerSet(software: "Avatar Stickers iOS/1574023061", isAnimated: true)
                            for (emotion, data) in animatedData {
                                if let compressed = try? data.gzipped(level: .bestCompression) {
                                    try? stickerSet.addSticker(data: .animation(compressed), emojis: [emotion])
                                }
                            }
                            try stickerSet.import()
                            exporting = false
                        } catch(let error) {
                            // Telegram Export Error
                            exporting = false
                        }
                    }
                    else {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/app/telegram-messenger/id686449807")!)
                    }
                }
                else {
                    // WhatsApp Export
                    if installed {
                        exporting = true
                        DispatchQueue.global(qos: .userInitiated).async {
                            do {
                                let stickerPack = try StickerPack(
                                    identifier: "avatar_stickers_ios_id1574023061_\(UUID())",
                                    name: "Face Emotions",
                                    publisher: "Avatar Stickers",
                                    trayImageFileName: "icon.png",
                                    animatedStickerPack: true,
                                    publisherWebsite: "https://facemotion.herokuapp.com",
                                    privacyPolicyWebsite: "https://facemotion.herokuapp.com/privacy",
                                    licenseAgreementWebsite: "https://facemotion.herokuapp.com/app"
                                )
                                
                                for (emotion, data) in animatedData {
                                    try stickerPack.addSticker(imageData: data, type: ImageDataExtension.webp, emojis: [emotion])
                                }
                                
                                stickerPack.sendToWhatsApp { completed in
                                    // Called when the sticker pack has been wrapped in a form that WhatsApp
                                    // can read and WhatsApp is about to open.
                                    exporting = false
                                }
                            } catch(let error) {
                                // WhatsApp Export Error
                                exporting = false
                            }
                        }
                    } else {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997")!)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 68)
                    .foregroundColor(Color.night)
                    .frame(width: 260, height: 54)
                    .overlay(
                        Group {
                            if installed && exporting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: isTelegram ? Color.sky : Color.grass))
                                    .accentColor(.white)
                            } else {
                                Text(installed ? "export" : "install")
                                    .font(.system(size: 22).weight(.bold))
                                    .foregroundColor(isTelegram ? .sky : .grass)
                            }
                        }
                    )
                    .padding(.bottom, 40)
            }
            .disabled(exporting)
        }
        .background(
            (isTelegram ? Color.sky : Color.grass)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    var installed: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        if isTelegram {
            return UIApplication.shared.canOpenURL(URL(string: "tg://")!)
        } else {
            guard UIDevice.current.userInterfaceIdiom == .phone else { return false } // No WhatsApp support for iPad yet
            return UIApplication.shared.canOpenURL(URL(string: "https://wa.me/+79951213460")!)
        }
        #endif
    }
}

struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExportView(isTelegram: true, image: .constant(nil))
            ExportView(isTelegram: false, image: .constant(nil))
        }
    }
}
