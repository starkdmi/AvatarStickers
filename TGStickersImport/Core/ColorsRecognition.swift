//
//  ColorRecognitions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit
import Chameleon

struct ColorsRecognition {
    static let skinColors = [
        UIColor(hexString: "#FD9841"), // TANNED
        UIColor(hexString: "#F8D25C"), // YELLOW
        UIColor(hexString: "#FFDBB4"), // PALE
        UIColor(hexString: "#EDB98A"), // LIGHT
        UIColor(hexString: "#D08B5B"), // BROWN
        UIColor(hexString: "#AE5D29"), // DARK_BROWN
        //UIColor(hexString: "#614335"), // BLACK
        UIColor(hexString: "#614336"), // BLACK
    ]
    
    static func skinColor(_ image: UIImage, _ completion: @escaping (String, String) -> Void) {
        image.preferredColor(using: skinColors, skin: true) { original, color in
            completion(original?.hexValue() ?? "", color?.hexValue() ?? "#F8D25C")
        }
    }
    
    static let clothesColors = [
        UIColor(hexString: "#262E33"), // BLACK
        UIColor(hexString: "#65C9FF"), // BLUE_01
        UIColor(hexString: "#5199E4"), // BLUE_02
        UIColor(hexString: "#25557C"), // BLUE_03
        UIColor(hexString: "#E6E6E6"), // GRAY_01
        UIColor(hexString: "#929598"), // GRAY_02
        
        UIColor(hexString: "#3C4F5C"), // HEATHER
        UIColor(hexString: "#B1E2FF"), // PASTEL_BLUE
        UIColor(hexString: "#A7FFC4"), // PASTEL_GREEN
        UIColor(hexString: "#FFDEB5"), // PASTEL_ORANGE
        UIColor(hexString: "#FFFFB1"), // PASTEL_YELLOW
        // UIColor(hexString: "#FF488E"), // PINK
        UIColor(hexString: "#FF488D"), // PINK
        UIColor(hexString: "#FF5C5C"), // RED
        UIColor(hexString: "#FFFFFF"), // WHITE
    ]
    
    static func clothesColor(_ image: UIImage, _ completion: @escaping (String, String, String) -> Void) {
        image.preferredColor(using: clothesColors) { original, color in
            let textColor = textColor(color ?? UIColor(hexString: "#FFFFFF")!)
            completion(original?.hexValue() ?? "", color?.hexValue() ?? "#3C4F5C", textColor.hexValue())
        }
    }
    
    static func textColor(_ backgroundColor: UIColor) -> UIColor {
        return UIColor(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: true)
    }
    
    static let hairColors = [
        // UIColor(hexString: "#A55728"), // AUBURN
        UIColor(hexString: "#A55727"), // AUBURN
        UIColor(hexString: "#2C1B18"), // BLACK
        UIColor(hexString: "#B58143"), // BLONDE
        UIColor(hexString: "#D6B370"), // BLONDE_GOLDEN
        UIColor(hexString: "#724133"), // BROWN
        UIColor(hexString: "#4A312C"), // BROWN_DARK
        // UIColor(hexString: "#F59797"), // PASTEL_PINK
        UIColor(hexString: "#F59798"), // PASTEL_PINK
        UIColor(hexString: "#ECDCBF"), // PLATINUM
        UIColor(hexString: "#C93305"), // RED
        //UIColor(hexString: "#E8E1E1"), // SILVER_GRAY
        UIColor(hexString: "#E8E1E2"), // SILVER_GRAY
    ]
    
    static func hairColor(_ image: UIImage, _ completion: @escaping (String, String) -> Void) {
        image.preferredColor(using: hairColors) { original, color in
            completion(original?.hexValue() ?? "", color?.hexValue() ?? "#2C1B18")
        }
    }
}
