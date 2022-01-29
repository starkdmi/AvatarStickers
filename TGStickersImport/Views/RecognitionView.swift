//
//  RecognitionView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Combine
import Lottie

typealias Color = SwiftUI.Color
typealias Animation = SwiftUI.Animation

struct RecognitionView: View {
    @StateObject private var model = RecognitionViewModel()
    
    @Binding var image: UIImage?
    
    @State var done = false
    @State var noFace = false
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    @State var isShadow: Bool = false
    
    @State private var showingActionSheet = false
    @State private var longPressed = false
    @State private var gotoTelegram = false
    @State private var gotoWhatsApp = false
    
    static let loadingAnimation = Lottie.Animation.named("recognition")
        
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.grass, .sea]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    if !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
                        Button {
                            image = nil
                        } label: {
                            Label(title: {
                                Text("back")
                            }, icon: {
                                Image(systemName: "chevron.left")
                            })
                            .font(.system(size: 24).weight(.heavy))
                            .foregroundColor(Color.night)
                            .padding(.top, 20)
                            .padding(.leading, 14)
                        }
                    }
                    Spacer()
                                              
                    if done {
                        Label(title: {
                            Text(model.male ? "male" : "female").animation(nil)
                        }, icon: {
                            Image(model.male ? "male" : "female").resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(maxWidth: 32, maxHeight: 32)
                        })
                        .labelStyle(GenderLabelStyle())
                        .font(.system(size: 24).weight(.heavy))
                        .foregroundColor(Color.night)
                        .padding(.top, 20)
                        .padding(.trailing, 18)
                        .onTapGesture {
                            withAnimation {
                                model.male.toggle()
                            }
                        }
                    }
                } 
                Spacer()
                
                VStack {
                    GeometryReader { geometry in
                        ZStack {
                            let clear = Color.night
                            let hairStroke = model.hairColor == .clear ? clear : model.hairColor
                            let hairFill = model.hairColor == .clear ? clear : model.hairColor

                            let skinStroke = model.skinColor == .clear ? clear : model.skinColor
                            let skinFill = model.skinColor == .clear ? clear : model.skinColor

                            let bodyStroke = model.bodyColor == .clear ? clear : model.bodyColor
                            let bodyFill = model.bodyColor == .clear ? clear : model.bodyColor

                            let text = model.textColor == .clear ? .white : model.textColor

                            BodyShape().fill(bodyFill)
                                .overlay(
                                    BodyShape()
                                        .stroke(lineWidth: 6).foregroundColor(bodyStroke)
                                )
                            NeckShape().fill(skinFill)
                                .overlay(
                                    NeckShape()
                                        .stroke(lineWidth: 6).foregroundColor(skinStroke)
                                )
                            if model.skinColor != .clear {
                                NeckShadowShape().fill(Color.clear)
                                    .shadow(color: .night.opacity(0.1), radius: 0.5, x: 0, y: 0.5)
                                    .offset(y: -geometry.size.height * 0.015)
                                    .scaleEffect(x: 0.93, y: 1.0, anchor: .center)
                            }
                            EarsShape().fill(skinFill)
                                .overlay(
                                    EarsShape()
                                        .stroke(lineWidth: 6).foregroundColor(skinStroke)
                                )
                            FaceShape().fill(skinFill)
                                .overlay(
                                    FaceShape()
                                        .stroke(lineWidth: 6).foregroundColor(skinStroke)
                                )
                            
                            if noFace {
                                EyesShape().fill(
                                    LinearGradient(gradient: Gradient(colors: [.grass, .sea]), startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                SadMouthShape().fill(
                                    LinearGradient(gradient: Gradient(colors: [.grass, .sea]), startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                            }

                            if model.male || model.hairColor == .clear {
                                HairShape().fill(hairFill)
                                    .overlay(
                                        HairShape()
                                            .stroke(lineWidth: 6).foregroundColor(hairStroke)
                                    )
                            } else {
                                HairGirlShape().fill(hairFill)
                                    .overlay(
                                        HairGirlShape()
                                            .stroke(lineWidth: 6).foregroundColor(hairStroke)
                                    )
                            }

                            if done {
                                VStack {
                                    TextField("Aa..", text: $model.string)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 46 : 24).weight(.heavy))
                                        .lineLimit(1)
                                        .foregroundColor(text)
                                        .background(Color.clear)
                                        .accentColor(text)
                                        .frame(maxWidth: geometry.size.width * 0.6)
                                        .offset(y: 4)
                                        .onAppear {
                                            // TextField placeholder color
                                            let placeholder = NSAttributedString(string: "Aa..", attributes: [
                                                NSAttributedString.Key.foregroundColor: UIColor(red: 252/255, green: 176/255, blue: 69/255, alpha: 1.0)
                                            ])
                                            UITextField.appearance().attributedPlaceholder = placeholder
                                        }
                                    if !model.isStringValid {
                                        Text("tshirtTextLimit")
                                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 24 : 16).weight(.heavy))
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                            .offset(y: UIDevice.current.userInterfaceIdiom == .pad ? -10 : -4)
                                    }

                                }
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.875)
                            }
                        }
                        .compositingGroup()
                        .shadow(color: .fire.opacity(0.9), radius: UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") ? 0 : (isShadow ? 16 : 0), x: 0, y: 0)
                        .onReceive(timer) { _ in
                            withAnimation(.linear(duration: 1.5)) {
                                isShadow.toggle()
                            }
                        }
                    }
                    .frame(minWidth: 240, minHeight: 240)
                    .aspectRatio(1.0, contentMode: .fit)
                    .offset(y: -20)
                    
                    VStack(spacing: 16) {
                        if done {
                            HStack {
                                Spacer()
                                ColorPicker("hairColor", selection: $model.hairColor, supportsOpacity: false)
                                    .font(.system(size: 24).weight(.heavy))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .foregroundColor(Color.night)
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                ColorPicker("skinColor", selection: $model.skinColor, supportsOpacity: false)
                                    .font(.system(size: 24).weight(.heavy))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .foregroundColor(Color.night)
                                Spacer()
                            }
                                
                            HStack {
                                Spacer()
                                ColorPicker("clothesColor", selection: $model.bodyColor, supportsOpacity: false)
                                    .font(.system(size: 24).weight(.heavy))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .foregroundColor(Color.night)
                                    .onChange(of: model.bodyColor) { color in
                                        if model.textColor == model.defaultTextColor, color != .clear, let cgColor = color.cgColor {
                                            let clothesColor = UIColor(cgColor: cgColor)
                                            let textColor = ColorsRecognition.textColor(clothesColor)
                                            let color = Color(textColor)
                                            model.textColor = color
                                            model.defaultTextColor = color
                                        }
                                  }
                                Spacer()
                            }
                            
                            if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > 700 {
                                HStack {
                                    Spacer()
                                    ColorPicker("textColor", selection: $model.textColor, supportsOpacity: false)
                                        .font(.system(size: 24).weight(.heavy))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        .foregroundColor(Color.night)
                                    Spacer()
                                }
                            }
                        } else {
                            if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > 700 { Spacer() }
                            if noFace {
                                // Error Message
                                Text(UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > 700 ? "noFaceLined" : "noFace")
                                    .font(Font.system(size: 32).weight(.heavy))
                                    .foregroundColor(Color.night.opacity(0.94))
                                    .multilineTextAlignment(.center)
                            } else {
                                // Loading
                                if let animation = Self.loadingAnimation {
                                    LottieView(animation: animation)
                                        .frame(minWidth: 140, minHeight: 140)
                                } else {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color.night))
                                }
                            }
                        }
                    }
                    .frame(height: 80)
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > 700 ? 36 : 16)
                    .padding(.bottom, 8)
                    .offset(y: -8)
                    .padding(.leading, UIScreen.main.bounds.width > 600 ? 80 : 28)
                    .padding(.trailing, UIScreen.main.bounds.width > 600 ? 80 : 28)
                }
                .padding()
                
                Spacer()
                            
                NavigationLink(destination: NavigationLazyView(AnimatedStickersView(parameters: model.exportParameters, image: $image)), isActive: $gotoTelegram) {
                    EmptyView()
                }
                NavigationLink(destination: NavigationLazyView(AnimatedStickersView(parameters: model.exportParameters, image: $image)), isActive: $gotoWhatsApp) {
                    EmptyView()
                }
                NavigationLink(destination: NavigationLazyView(AnimatedStickersView(parameters: model.exportParameters, image: $image))) {
                    RoundedRectangle(cornerRadius: 60)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 35/255, green: 43/255, blue: 43/255), Color.night]), startPoint: .bottomLeading, endPoint: .topTrailing)
                        )
                        .frame(width: 260, height: 54)
                        .shadow(color: .love, radius: done ? 5 : 0, x: 0, y: 0)
                        .overlay(
                            Group {
                                if (done && model.isStringValid) {
                                    Text("generate")
                                        .font(.system(size: 22).weight(.bold))
                                        .gradientForeground(colors: [.fire, .love])
                                } else {
                                    Text("generate")
                                        .font(.system(size: 22).weight(.bold))
                                        .foregroundColor(.gray)
                                        .opacity(0.25)
                                }
                            }
                        )
                        .padding(.bottom, 36)
                }
                .disabled(!done)
                .onLongPressGesture(pressing: { state in
                    longPressed = state
                    if done {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if longPressed {
                                withAnimation(.linear.delay(0.25)) {
                                    done = false
                                }
                                self.showingActionSheet = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.125) {
                                    self.done = true
                                }
                            }
                        }
                    }

                }, perform: {
                    longPressed = false
                })
                .actionSheet(isPresented: $showingActionSheet) {
                    var buttons: [ActionSheet.Button] = [
                        .default(Text("Telegram")) { self.model.isTelegram = true; self.gotoTelegram = true }
                    ]
                    let whatsapp = ActionSheet.Button.default(Text("WhatsApp")) { self.model.isTelegram = false; self.gotoWhatsApp = true }
                    
                    #if DEBUG
                    if CommandLine.arguments.contains("-LOCAL") {
                        buttons.append(whatsapp)
                    } else {
                        // WhatsApp mockup animations does not exists yet
                    }
                    #else
                    buttons.append(whatsapp)
                    #endif
                    
                    buttons.append(.cancel())
                    return ActionSheet(title: Text("selectExport"), buttons: buttons)
                }
            }
        }
        .onAppear {
            if let image = image, let cgImage = image.cgImage {
                model.recognize(cgImage) { status in
                    withAnimation {
                        if status {
                            self.done = true
                        } else {
                            self.noFace = true
                        }
                        self.isShadow = false
                    }
                    
                    timer.upstream.connect().cancel()
                }
            }
        }
    }
}

struct RecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        if let path = Bundle.main.path(forResource: "avatar", ofType: "jpeg", inDirectory: "MockupAnimations"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let image = UIImage(data: data) {
            RecognitionView(image: .constant(image))
        }
    }
}
