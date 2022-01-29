//
//  CGImage+Extensions.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit

extension CGImage {
    func resized(imageWidth: Float? = nil, imageHeight: Float? = nil, maxWidth: Float = 512.0, maxHeight: Float = 512.0) -> CGImage? {
        var ratio: Float = 0.0
        let imageWidth = imageWidth ?? Float(self.width)
        let imageHeight = imageHeight ?? Float(self.height)
        let maxWidth: Float = maxWidth
        let maxHeight: Float = maxHeight
            
        // Get ratio (landscape or portrait)
        if (imageWidth > imageHeight) {
            ratio = maxWidth / imageWidth
        } else {
            ratio = maxHeight / imageHeight
        }
        
        // Calculate new size based on the ratio
        if ratio > 1 {
            ratio = 1
        }
        
        let width = imageWidth * ratio
        let height = imageHeight * ratio
        
        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: self.bitsPerComponent, bytesPerRow: self.bytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }
        
        // draw image to context (resizing it)
        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: Int(width), height: Int(height)))
        
        // extract resulting image from context
        return context.makeImage()
    }
    
    class func generate(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> CGImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.cgImage
    }
    
    /*func rotated(radians: CGFloat) -> CGImage? {
        let size = CGSize(width: self.width, height: self.height)
        
        var newSize = CGRect(origin: .zero, size: size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: radians)
        // Flip back to normal
        context.scaleBy(x: 1.0, y: -1.0)
        // Draw the image at its center
        context.draw(self, in: CGRect(x: -self.width/2, y: -self.height/2, width: self.width, height: self.height))
        return context.makeImage()
    }*/
}
