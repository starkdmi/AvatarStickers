//
//  AnimatedStickersView.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI
import Combine
import Lottie
import SDWebImageSwiftUI

struct AnimationStore: Identifiable {
    let id = UUID()
    var animation: Lottie.Animation?
    var emotion: String
    var selected: Bool = true
    var data: Data
}

struct AnimatedStickersView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("useAnimations") var useAnimations: Bool = true
    
    var parameters: [String: String]
    @Binding var image: UIImage?
    let emotions = AvatarKeys.emotions
        
    @State private var cancellables: Set<AnyCancellable> = []
   
    @State var animations: [AnimationStore] = [] // lottie displaying
    @State var firstAnimationLoaded = false
    @State var errors: [String: Bool] = [:]
    @State var timeout = false
    @State var loading = true
    
    @State var done = false
    @State var data: [String: Data] = [:]
    var datas: [String: Data] { // export
        guard !done else { return self.data }
        done = true
        
        let stickerSet = StickerSet(context: managedObjectContext)
        stickerSet.date = Date()
        stickerSet.source = parameters["service"]
        
        var data: [String: Data] = [:]
        for animation in animations {
            if animation.selected {
                data[animation.emotion] = animation.data
                
                let sticker = Sticker(context: managedObjectContext)
                sticker.emotion = animation.emotion
                sticker.animation = animation.data
                stickerSet.addToStickers(sticker)
            }
        }
        
        self.data = data
        
        try? managedObjectContext.save()
                
        return data
    }
    
    let gridColumns = [
        GridItem(),
        GridItem(),
        GridItem()
    ]
        
    static let loadingAnimation = Lottie.Animation.named("loading")
    @State var noNetworkAnimation: Lottie.Animation?
    
    @State var viewStickers: [Int: Bool] = [:]
        
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.grass, .sea]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
            
            if !firstAnimationLoaded || (timeout && animations.isEmpty) { // animations.isEmpty
                if (errors.count != emotions.count) && !timeout {
                    Group {
                        if let animation = Self.loadingAnimation {
                            LottieView(animation: animation)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.night))
                        }
                    }
                    .onAppear(perform: downloadStickers)
                } else {
                    VStack {
                        HStack {
                            if !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .resizable()
                                        .font(Font.system(size: 36).weight(.heavy))
                                        .foregroundColor(Color.night)
                                        .frame(width: 32, height: 27)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 14)
                                        .padding(.top, 8)
                                        .padding(.leading, 16)
                                }
                            }

                            Spacer()
                        }
                        
                        if let animation = noNetworkAnimation {
                            Spacer()
                            LottieView(animation: animation)
                        } else {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .main))
                        }
                        
                        Spacer()
                        Button {
                            withAnimation {
                                checkTimeout()
                                errors = [:]
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 60)
                                .foregroundColor(Color.night)
                                .frame(width: 260, height: 54)
                                .overlay(
                                    Text("tryAgain")
                                        .font(.system(size: 22).weight(.bold))
                                        .gradientForeground(colors: [.grass, .sea])
                                )
                                .padding(.bottom, 20)
                        }
                    }
                }
            } else {
                VStack {
                    ZStack {
                        ScrollView(showsIndicators: false) {
                            LazyVGrid(columns: gridColumns, spacing: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 24) {
                                Section(header:
                                           
                                Group {
                                    if UIScreen.main.bounds.width >= 395 {
                                        ZStack {
                                            HStack {
                                                if !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
                                                    Button {
                                                        presentationMode.wrappedValue.dismiss()
                                                    } label: {
                                                        Image(systemName: "arrow.backward")
                                                            .resizable()
                                                            .font(Font.system(size: 36).weight(.heavy))
                                                            .foregroundColor(Color.night)
                                                            .frame(width: 30, height: 26)
                                                            .padding(.horizontal, 12)
                                                            .padding(.vertical, 14)
                                                            .padding(.leading, 16)
                                                    }
                                                }

                                                Spacer()
                                            }

                                            Text("select")
                                                .font(Font.system(size: 36).weight(.heavy))
                                                .foregroundColor(Color.night)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 18 : 12)
                                                .padding(.vertical, 6)
                                        }
                                    } else {
                                        HStack {
                                            if showBack && !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
                                                Button {
                                                    presentationMode.wrappedValue.dismiss()
                                                } label: {
                                                    Image(systemName: "arrow.backward")
                                                        .resizable()
                                                        .frame(width: 30, height: 26)
                                                }
                                            }
                                            Text("select")
                                                .padding(.leading, showBack ? 8 : 0)
                                            if showBack {
                                                Spacer().frame(maxWidth: 20)
                                            }
                                        }
                                        .font(Font.system(size: 36).weight(.heavy))
                                        .foregroundColor(Color.night)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 18 : (showBack ? 16 : 12))
                                        .padding(.vertical, 6)
                                    }
                                }
                                .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 8 : 4)
                                ) {
                                ForEach(Array(animations.enumerated()), id: \.offset) { index, animation in
                                    
                                    ZStack(alignment: .top) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .aspectRatio(1.0, contentMode: .fit)
                                            .foregroundColor(.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.night, lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3)
                                                    .shadow(color: .main, radius: 2, x: 1, y: 1)
                                                    .overlay(
                                                        Group {
                                                            if self.parameters["service"] == "whatsapp" {
                                                                AnimatedImage(data: animation.data, isAnimating: .constant(viewStickers[index] ?? true))
                                                                    .resizable()
                                                                    .mask(RoundedRectangle(cornerRadius: 6))
                                                                    .padding(1.5)
                                                                    .aspectRatio(1.0, contentMode: .fit)
                                                                    .onDisappear {
                                                                        viewStickers[index] = false
                                                                    }
                                                                    .onAppear {
                                                                        // It fixes animation stops while out of device screen
                                                                        if viewStickers[index] == false {
                                                                            viewStickers[index] = true
                                                                        }
                                                                    }
                                                            } else {
                                                                if let lottie = animation.animation {
                                                                    LottieView(animation: lottie)
                                                                        .mask(RoundedRectangle(cornerRadius: 6))
                                                                        .padding(1.5)
                                                                        .aspectRatio(1.0, contentMode: .fit)
                                                                }
                                                            }
                                                        }
                                                    )
                                                    .opacity(animation.selected ? 1.0 : 0.6)
                                            )
                                        
                                        Circle()
                                            .stroke(Color.night, lineWidth: UIDevice.current.userInterfaceIdiom == .pad ? 6 : 3)
                                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 30, height: UIDevice.current.userInterfaceIdiom == .pad ? 40 : 30)
                                            .background(
                                                    Color.night
                                                        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 0 : -1.5)
                                                        .mask(Circle())
                                            )
                                            .offset(y: UIDevice.current.userInterfaceIdiom == .pad ? -20 : -15)
                                            .overlay(
                                                Text(animation.emotion)
                                                    .opacity(animation.selected ? 1.0 : 0.6)
                                                    .offset(y: UIDevice.current.userInterfaceIdiom == .pad ? -20 : -15)
                                                    .font(UIDevice.current.userInterfaceIdiom == .pad ? .system(size: 26) : nil)
                                            )
                                    }
                                    .onTapGesture {
                                        animations[index].selected.toggle()
                                    }
                                }
                                .padding(.leading, 4)
                                .padding(.trailing, 4)
                                }
                            }
                            .padding(.top, 18)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom, 24)
                            Spacer().frame(height: 96)
                        }

                        VStack {
                            Spacer()
                            NavigationLink(destination: NavigationLazyView(ExportView(isTelegram: parameters["service"] == "telegram", animatedData: datas, image: $image))) { }
                                .buttonStyle(ExportButtonStyle(disabled: disabled, loading: animations.count != emotions.count, processing: $loading))
                                .disabled(disabled)
                                .padding()
                        }
                        
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
        .onAppear {
            if self.noNetworkAnimation == nil {
                DispatchQueue.global().async {
                    let animation = Lottie.Animation.named("dynosaur")
                    DispatchQueue.main.async {
                        self.noNetworkAnimation = animation
                    }
                }
            }
        
            checkTimeout()
        }
    }
    
    var disabled: Bool {
        (animations.count != emotions.count && loading)
        ||
        ((parameters["service"] == "telegram" ?
            animations.filter { $0.selected }.count == 0 : // telegram non-empty pack
            animations.filter { $0.selected }.count < 3)) // whatsApp minimum 3 stickers per pack
    }
    
    var showBack: Bool {
        UIScreen.main.bounds.width > 375 && ((!firstAnimationLoaded && (timeout && animations.isEmpty)) || animations.count == emotions.count)
    }
    
    func downloadStickers() {
        if animations.isEmpty {
            // Process parameters
            let args = AvatarKeys.processKeys(parameters)
            
            // Network Request
            fetch(args)
        }
    }
    
    func fetch(_ data: [String: String]) {
        for emotion in emotions {
            let parameters = AvatarKeys.processEmotions(emotion, with: data)
            
            try? Network.load(for: parameters)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            errors[emotion] = true
                        }
                    case .finished:
                        break
                    }
                }) { data in
                    if self.parameters["service"] == "whatsapp" {
                        // WhatsApp WebP
                        DispatchQueue.main.async {
                            withAnimation {
                                if animations.firstIndex(where: { $0.emotion == emotion }) == nil {
                                    animations.append(AnimationStore(emotion: emotion, data: data))
                                    firstAnimationLoaded = true
                                    errors[emotion] = nil
                                }
                            }
                        }
                    } else {
                        // Telegram Lottie
                        DispatchQueue.global().async {
                            if let animation = try? JSONDecoder().decode(Lottie.Animation.self, from: data) {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        if animations.firstIndex(where: { $0.emotion == emotion }) == nil {
                                            animations.append(AnimationStore(animation: animation, emotion: emotion, data: data))
                                            firstAnimationLoaded = true
                                            errors[emotion] = nil
                                        }
                                    }
                                }
                            } else {
                                // Couldn't preview sticker
                                DispatchQueue.main.async {
                                    // Lottie Preview Error
                                    errors[emotion] = true
                                }
                            }
                        }
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func checkTimeout() {
        timeout = false
        loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + (parameters["service"] == "telegram" ? 16.0 : 24.0)) {
            if !self.firstAnimationLoaded {
                withAnimation {
                    timeout = true
                }
            }
            
            withAnimation {
                loading = false
            }
        }
    }
}

struct AnimatedStickersView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedStickersView(parameters: [:], image: .constant(nil))
    }
}
