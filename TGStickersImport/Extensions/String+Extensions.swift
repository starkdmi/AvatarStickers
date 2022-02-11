//
//  String+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import SwiftUI

extension String {
    /// Generate image from string
    /// Used for Emoji based images
    /// - Parameters:
    ///   - fontSize: Font Size
    ///   - bgColor: Background Color
    ///   - imageSize: Image Size
    /// - Returns: Generated Image
    func image(fontSize: CGFloat = 40, bgColor: UIColor = UIColor.clear, imageSize: CGSize? = nil) -> UIImage? {
           let font = UIFont.systemFont(ofSize: fontSize)
           let attributes = [NSAttributedString.Key.font: font]
           let imageSize = imageSize ?? self.size(withAttributes: attributes)

           UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
           bgColor.set()
           let rect = CGRect(origin: .zero, size: imageSize)
           UIRectFill(rect)
           self.draw(in: rect, withAttributes: [.font: font])
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

#if DEBUG
extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\", "\n"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        
        current = current.replacingOccurrences(of: "\\n", with: "")
        current = current.replacingOccurrences(of: "\n", with: "")
        current = current.replacingOccurrences(of: "\\", with: "")

        return current
    }
}
#endif
