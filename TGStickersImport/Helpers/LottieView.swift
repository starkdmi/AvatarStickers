//
//  LottieView.swift
//  TGStickersImport
//
//  Created by Starkov Dmitry on 01/07/2021.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    var animation: Lottie.Animation
    var run: Bool = true
                    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
                
        animationView.animation = animation
        // animationView.respectAnimationFrameRate = true
        animationView.contentMode = .scaleAspectFit
        
        // animationView.loopMode = LottieLoopMode.autoReverse
        animationView.loopMode = LottieLoopMode.loop
        
        if run {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiview: UIView, context: UIViewRepresentableContext<LottieView>) {
        if !animationView.isAnimationPlaying {
            if run {
                animationView.play()
            } else {
                animationView.stop()
            }
        }
    }
}

struct LazyLottieView: UIViewRepresentable {
    let animationView = AnimationView()
    var data: Data
                    
    func makeUIView(context: UIViewRepresentableContext<LazyLottieView>) -> UIView {
        let view = UIView()
        
        DispatchQueue.global(qos: .userInteractive).async {
            var animation: Lottie.Animation?
            if let cached = LottieCache.shared.object(forKey: self.data as NSData) {
                animation = cached
            } else if let loaded = try? JSONDecoder().decode(Lottie.Animation.self, from: self.data) {
                animation = loaded
                LottieCache.shared.setObject(loaded, forKey: self.data as NSData)
            }
            
            if let animation = animation {
                DispatchQueue.main.async {
                    self.animationView.animation = animation
                    animationView.play()
                }
            }
        }
        
        // animationView.respectAnimationFrameRate = true
        animationView.contentMode = .scaleAspectFit
        
        // animationView.loopMode = LottieLoopMode.autoReverse
        animationView.loopMode = LottieLoopMode.loop
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiview: UIView, context: UIViewRepresentableContext<LazyLottieView>) {
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}

struct LottieCache {
    static let shared = NSCache<NSData, Lottie.Animation>()
}
