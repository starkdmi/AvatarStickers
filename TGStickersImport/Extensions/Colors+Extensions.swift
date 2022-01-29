//
//  Colors+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation
import SwiftUI

extension Color {
    static let night = Color(red: 43/255, green: 43/255, blue: 43/255) // black
    static let fire = Color(red: 252/255, green: 176/255, blue: 69/255) // orange
    static let love = Color(red: 253/255, green: 29/255, blue: 29/255) // red
        
    // WhatsApp colors
    static let grass = Color(red: 37/255, green: 211/255, blue: 102/255) // green
    static let sea = Color(red: 52/255, green: 183/255, blue: 241/255) // blue
    static let main = Color(red: 45/255, green: 197/255, blue: 172/255) // blue & green blend
    static let darkGreen = Color(red: 7/255, green: 94/255, blue: 84/255)
    
    // Telegram colors
    static let sky = Color(red: 0, green: 136/255, blue: 204/255) // blue
}

extension UIColor {
    static let main = UIColor(red: 252/255, green: 176/255, blue: 69/255, alpha: 0.9) // orange
    static let night = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0) // black
    
    // WhatsApp colors
    static let grass = UIColor(red: 37/255, green: 211/255, blue: 102/255, alpha: 1.0) // green
    static let sea = UIColor(red: 52/255, green: 183/255, blue: 241/255, alpha: 1.0) // blue
}
