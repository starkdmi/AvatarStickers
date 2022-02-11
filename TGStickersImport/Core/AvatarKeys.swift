//
//  AvatarKeys.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation

struct AvatarKeys {
        
    #if DEBUG
    static var emotions: [String] = ["😍", "😂", "✨", "😇", "❤️", "😔", "😊", "😭", "😡"] // iPhone 8
    // private let emotions: [String] = ["😍", "😂", "✨", "😇", "❤️", "😔", "😊", "😭", "😉", "😐", "😡"] // iPhone 11
    #else
    static let emotions: [String] = ["😂", "❤️", "😍", "✨", "😇", "😊", "😉", "😐", "😡", "😔", "😭", "🏀", "⚽️"]
    #endif
    
    /// Convert face features into format readable by Server
    /// - Parameter parameters: Original pairs of key value features
    /// - Returns: Modified pairs of key value features
    static func processKeys(_ parameters: [String: String]) -> [String: String] {
        var data = parameters
        
        // Clothes default values
        data["clothes"] = ["blazer_shirt", "blazer_sweater", "collar_sweater", "graphic_shirt", "hoodie", "overall", "shirt_crew_neck", "shirt_scoop_neck", "shirt_v_neck"].randomElement()!
        data["shirt_graphic"] = ["bat", "bear", "cumbia", "deer", "diamond", "hola", "pizza", "resist", "selena", "skull_outline", "skull"].randomElement()!
        
        // Pre-define hair style
        if let gender = data["gender"] {
            switch gender {
            case "male":
                data["hair"] = ["caesar_side_part", "caesar", "frizzle", "short_curly", "short_flat", "short_waved"].randomElement()!
            case "female":
                data["hair"] = ["long_not_too_long", "mia_wallace", "shaggy_mullet", "straight_1", "straight_2", "straight_strand", "big_hair", "bob", "curly", "curvy", "dreads", "fro_band", "fro"].randomElement()!
            default:
                break
            }
        }
        
        for (key, value) in data {
            switch key {
            
            case "beard":
                var beard = ""
                let confidence = Float(value) ?? 0.0
                
                if confidence >= 0.9 {
                    beard = "beard_magestic"
                } else if confidence >= 0.75 {
                    beard = "beard_medium"
                } else if confidence >= 0.5 {
                    beard = "beard_light"
                }
                data["facialHair"] = beard
            case "mustache":
                var mustache = ""
                if let confidence = Float(value), confidence >= 0.7 {
                    if let beard = data["beard"], let confidence = Float(beard), confidence >= 0.75 {
                        mustache = ["beard_medium", "beard_light"].randomElement()!
                    } else {
                        mustache = ["moustache_fancy", "moustache_magnum"].randomElement()!
                    }
                }
                data["facialHair"] = mustache
            case "Black_Hair":
                if let confidence = Float(value), confidence >= 0.75 {
                    let hairColor = "#2C1B18"
                    data["hairColor"] = hairColor
                    data["beardColor"] = hairColor
                }
            case "Blond_Hair":
                if let confidence = Float(value), confidence >= 0.75, !["#B58143", "#D6B370", "#ECDCBF"].contains(data["hairColor"]) {
                    let hairColor = ["#B58143", "#D6B370", "#ECDCBF"].randomElement()!
                    data["hairColor"] = hairColor
                    data["beardColor"] = hairColor
                }
            case "Brown_Hair":
                if let confidence = Float(value), confidence >= 0.75, !["#A55727", "#724133", "#4A312C", "#C93305"].contains(data["hairColor"]) {
                    let hairColor = ["#A55727", "#724133", "#4A312C", "#C93305"].randomElement()!
                    data["hairColor"] = hairColor
                    data["beardColor"] = hairColor
                }
            case "Gray_Hair":
                if let confidence = Float(value), confidence >= 0.75 {
                    let hairColor = "#E8E1E2"
                    data["hairColor"] = hairColor
                    data["beardColor"] = hairColor
                }
            case "glasses":
                switch value {
                case "glasses":
                    data["accessory"] = ["kurt", "prescription_01", "prescription_02", "round", "sunglasses", "wayfarers"].randomElement()!
                case "none":
                    data["accessory"] = ""
                default:
                    data["accessory"] = ""
                }
                data["glasses"] = nil
            case "Bald":
                let sidesConfidence = Float(data["Sideburns"] ?? "0.0") ?? 0.0
                if let confidence = Float(value),
                    data["hairStyle"] == key && confidence > 0.3
                    || (sidesConfidence > 0.5 && confidence > 0.3)
                    || (sidesConfidence > 0.45 && confidence > 0.35)
                    || (sidesConfidence > 0.4 && confidence > 0.4)
                    || (sidesConfidence > 0.35 && confidence > 0.45)
                    || confidence > 0.5 {
                    data["hair"] = "no_hair"
                }
            case "Straight_Hair":
                if let gender = data["gender"], let confidence = Float(value), confidence >= 0.5 {
                    switch gender {
                    case "male":
                        data["hair"] = ["caesar_side_part", "caesar", "frizzle", "short_curly", "short_flat", "short_waved"].randomElement()!
                    case "female":
                        data["hair"] = ["long_not_too_long", "mia_wallace", "shaggy_mullet", "straight_1", "straight_2", "straight_strand"].randomElement()!
                    default:
                        data["hair"] = ["caesar_side_part", "caesar"].randomElement()!
                    }
                }
            case "Wavy_Hair":
                if let gender = data["gender"], let confidence = Float(value), confidence >= 0.5 {
                    switch gender {
                    case "male":
                        data["hair"] = ["caesar_side_part", "caesar", "frizzle", "short_curly", "short_flat",  "short_waved", "short_dreads_1", "short_dreads_2"].randomElement()!
                    case "female":
                        data["hair"] = ["big_hair", "bob", "curly", "curvy", "dreads", "fro_band", "fro"].randomElement()!
                    default:
                        data["hair"] = ["caesar_side_part", "caesar"].randomElement()!
                    }
                }
            case "Bangs":
                if let gender = data["gender"], let confidence = Float(value), confidence >= 0.5 {
                    switch gender {
                    case "male":
                        data["hair"] = "short_round"
                    case "female":
                        data["hair"] = ["bob", "mia_wallace", "long_not_too_long", "straight_strand", "shaggy_mullet"].randomElement()!
                    default:
                        data["hair"] = "short_round"
                    }
                }
            case "Wearing_Hat":
                if let confidence = Float(value), confidence >= 0.75 {
                    data["hair"] = "caesar"
                }
            case "shirt_text":
                if value != "" {
                    data["clothes"] = "graphic_shirt"
                    data["shirt_graphic"] = "custom_text"
                }
            default: break
            }
        }
        
        data["beard2"] = data["beard"]
        data["beard"] = data["facialHair"]
                  
        return data
    }
    
    /// Add the face features based on emotion provided
    /// - Parameters:
    ///   - emotion: Sticker emotion
    ///   - data: Original pairs of key value features
    /// - Returns: Modified pairs of key value features
    static func processEmotions(_ emotion: String, with data: [String: String]) -> [String: String] {
        var parameters = data
        
        switch emotion {
        case "🤩", "✨": // Excited 😲
            parameters["emotion"] = "Excited"
            let random = Int.random(in: 1...3)
            switch random {
            case 1:
                parameters["eyebrows"] = "raised_excited"
                parameters["eyes"] = "eye_roll"
                parameters["mouth"] = "smile"
            case 2:
                parameters["eyebrows"] = "raised_excited_natural"
                parameters["eyes"] = "happy"
                parameters["mouth"] = "disbelief"
            case 3:
                parameters["eyebrows"] = "raised_excited_natural"
                parameters["eyes"] = "eye_roll"
                parameters["mouth"] = "grimace"
            default:
                parameters["eyebrows"] = "default"
                parameters["eyes"] = "default"
                parameters["mouth"] = "default"
            }
        case "😢", "😖", "☹️", "😔": // Sad
            parameters["emotion"] = "Sad"
            parameters["eyebrows"] = ["default_natural", "default", "sad_concerned_natural", "sad_concerned"].randomElement()!
            parameters["eyes"] = "cry"
            parameters["mouth"] = ["sad", "serious", "disbelief"].randomElement()!
        case "😂": // Laugh
            parameters["emotion"] = "Laugh"
            parameters["eyebrows"] = ["default_natural", "default", "up_down", "up_down_natural"].randomElement()!
            parameters["eyes"] = "happy"
            parameters["mouth"] = "smile"
        case "😭": // Crying
            parameters["emotion"] = "Crying"
            parameters["eyebrows"] = "sad_concerned"
            parameters["eyes"] = "cry"
            parameters["mouth"] = "disbelief"
        case "❤️": // Love
            parameters["emotion"] = "Love"
            parameters["eyebrows"] = ["default_natural", "default"].randomElement()!
            parameters["eyes"] = "heart"
            parameters["mouth"] = ["tongue", "smile"].randomElement()!
        case "😍": // Amazing 🤩 ✨
            parameters["emotion"] = "Amazing"
            parameters["eyebrows"] = ["default_natural", "default"].randomElement()!
            parameters["eyes"] = "heart"
            parameters["mouth"] = ["tongue", "smile",  "scream_open"].randomElement()!
        case "😇": // Anglel, Please 🙏🏻
            parameters["emotion"] = "Please"
            parameters["eyebrows"] = ["sad_concerned_natural", "sad_concerned", "default"].randomElement()!
            parameters["eyes"] = ["side", "happy", "squint"].randomElement()!
            parameters["mouth"] = ["smile", "eating"].randomElement()!
        case "😊": // Smile
            parameters["emotion"] = "Smile"
            parameters["eyebrows"] = "default"
            parameters["eyes"] = ["side", "happy", "squint"].randomElement()!
            parameters["mouth"] = "eating"
        case "😉": // Wink
            parameters["emotion"] = "Wink"
            parameters["eyebrows"] = ["default", "up_down"].randomElement()!
            parameters["eyes"] = ["wink", "wink_wacky"].randomElement()!
            parameters["mouth"] = ["smile", "twinkle"].randomElement()!
        case "😐": // Emotionless
            parameters["emotion"] = "Emotionless"
            parameters["eyebrows"] = ["side", "closed"].randomElement()!
            parameters["eyes"] = "default"
            parameters["mouth"] = "serious"
        case "😡": // Angry 🤬
            parameters["emotion"] = "Angry"
            parameters["eyebrows"] = ["angry", "angry_natural"].randomElement()!
            parameters["eyes"] = ["squint", "eye_roll"].randomElement()!
            parameters["mouth"] = ["serious", "scream_open"].randomElement()!
        case "🏀": // Basket Ball
            parameters["emotion"] = "Basketball"
            parameters["eyebrows"] = "default"
            parameters["eyes"] = "happy"
            parameters["mouth"] = "smile"
        case "⚽️": // Football
            parameters["emotion"] = "Football"
            parameters["eyebrows"] = "default"
            parameters["eyes"] = "happy"
            parameters["mouth"] = "smile"
        default: // Default
            parameters["emotion"] = ""
            parameters["eyebrows"] = "default"
            parameters["eyes"] = "default"
            parameters["mouth"] = "default"
        }
        
        return parameters
    }
}
