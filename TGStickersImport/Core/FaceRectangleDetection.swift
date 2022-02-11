//
//  FaceRectangleDetection.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit
import Vision

struct FaceRectangleDetection {
    
    /// Detect the face rectangle from image
    /// - Parameters:
    ///   - image: Image to be proceed
    ///   - completion: Function to proceed the results which includes
    ///     `CGRect` - Face rectangle
    ///     `CGFloat` - Angle of face rotation
    static func detect(_ image: CGImage, _ completion: @escaping (CGRect, CGFloat) -> Void) {
        let bounds = CGRect(x: 0, y: 0, width: image.width, height: image.height)
               
        let request = VNDetectFaceRectanglesRequest() { request, error in
            guard let face = request.results?.first as? VNFaceObservation, let angle = face.roll as? CGFloat else {
                completion(.zero, 0.0)
                return
            }
                                    
            let faceBox = boundingBox(forRegionOfInterest: face.boundingBox, withinImageBounds: bounds)
                        
            let scale: CGFloat = 0.6
            let increased = CGRect(
                x: faceBox.minX,
                y: faceBox.minY - faceBox.height, // Fix y position
                width: faceBox.width,
                height: faceBox.height
            ).insetBy(dx: -faceBox.width * scale, dy: -faceBox.height * scale) // Scale up
                                        
            completion(increased, angle)
        }
        
        let handler = VNImageRequestHandler(cgImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("VNDetectFaceRectanglesRequest", error)
            }
        }
    }
    
    static func boundingBox(forRegionOfInterest: CGRect, withinImageBounds bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height
        
        // Begin with input rect
        var rect = forRegionOfInterest
        
        // Reposition origin
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + bounds.origin.y
        
        // Rescale normalized coordinates
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight
        
        return rect
    }
}
