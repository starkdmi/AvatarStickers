//
//  UIImage+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit
import Chameleon

extension UIImage {
    
    ///  Calculate the average color and find the nearest one from provided colors list
    /// - Parameters:
    ///   - colors: List of colors from which one will be selected
    ///   - skin: Does the image contains the skin part
    ///   - completion: Function with two colors
    ///     `UIColor` - Average color detected from image
    ///     `UIColor` - Nearest color to average one from colors list
    func preferredColor(using colors: [UIColor?] = [], skin: Bool = false, _ completion: @escaping (UIColor?, UIColor?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let imageColors = NSArray(ofColorsFrom: self, withFlatScheme: false) as! [UIColor]
            
            if colors.isEmpty {
                completion(imageColors.first, nil)
                return
            }
            
            var mainColor: UIColor?
            if skin {
                for imageColor in imageColors {
                    var hue: CGFloat = 0
                    var saturation: CGFloat = 0
                    var brightness: CGFloat = 0
                    var alpha: CGFloat = 0
                    imageColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
                    
                    hue *= 255
                    saturation *= 255
                    brightness *= 255
                    
                    // Skin tone values
                    // hue: 0 to 30-34
                    // saturation: 40-48 to 185-255
                    // brightness: 112-118 to 185-255
                    if (hue >= 0 && hue <= 34) && (saturation >= 40 && saturation <= 255) && (brightness >= 116 && brightness <= 255) {
                        mainColor = imageColor
                        break
                    }
                }
            }
                        
            if mainColor == nil {
                for imageColor in imageColors {
                    guard imageColor.cgColor.components != [0.0, 0.0, 0.0, 0.0] else { continue }
                    mainColor = imageColor
                    break
                }
            }
            
            guard let components = mainColor?.cgColor.components, components.count == 4, let first = imageColors.first else {
                completion(imageColors.first, nil)
                return
            }
            let sum = components[0]+components[1]+components[2]+components[3]
                        
            var minimal = (difference: CGFloat(4.0), color: first) // UIColor.clear
            for color in colors {
                guard let color = color, let comp = color.cgColor.components, comp.count == 4 else { continue }
                
                let componentsSum = comp[0]+comp[1]+comp[2]+comp[3]
                let difference = abs(sum - componentsSum)
                                    
                if difference < minimal.difference {
                    minimal.difference = difference
                    minimal.color = color
                }
            }
                            
            completion(mainColor, minimal.color)
        }
    }
    
    /// Apply gradinet to current image
    /// - Parameter colorsArr: Gradient colors
    /// - Returns: Image with the gradient effect
    func tintedWithLinearGradientColors(colorsArr: [CGColor]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)

        context.setBlendMode(.normal)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)

        // Create gradient
        let colors = colorsArr as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)

        guard let cgImage = self.cgImage, let gradient = gradient else {
            return self
        }
        
        // Apply gradient
        context.clip(to: rect, mask: cgImage)
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: self.size.height), end: CGPoint(x: self.size.width, y: 0), options: .drawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return gradientImage ?? self
    }
    
    /*
    /// Rotate image
    /// - Parameter radians: Angle of rotation
    /// - Returns: Rotated Image
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: radians)
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }*/
    
}
