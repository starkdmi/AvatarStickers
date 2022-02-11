//
//  FaceRecognition.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import UIKit
import Vision

struct FaceRecognition {
    
    enum FaceKey: Int {
        case background = 0
        case skin, l_brow, r_brow, l_eye, r_eye, eye_g, l_ear, r_ear, ear_r
        case nose, mouth, u_lip, l_lip, neck, neck_l, cloth, hair, hat
    }
    
    struct BufferData {
        var context: CGContext
        var buffer: UnsafeMutablePointer<RGBA32>
    }
    
    struct ProcessData: Hashable {
        var key: FaceKey
        var image: CGImage
        var mode: ProcessMode
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(key)
        }
    }

    enum ProcessMode {
        case insert, delete
    }
    
    static var faceModel: VNCoreMLModel? = try? VNCoreMLModel(for: FaceParsing().model)
    
    /// Convert AI model segmentation output into array of separeted face parts
    /// - Parameters:
    ///   - segmenation: Array of colored pixels, each Color is equals to some `FaceKey`
    ///   - original: Unmodified Ai model input image
    ///   - data: Array of `ProcessData` which defines which parts shoul be proceed and be in output array
    /// - Returns: Array of pairs `FaceKey` and `CGImage` which contains proceed face parts
    static func processFaceParts(of segmenation: Array<Int32>, with original: CGImage, for data: [ProcessData]) -> [FaceKey: CGImage] {
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = 512 // inputCGImage.width
        let height           = 512 // inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        func bind(_ image: CGImage) -> BufferData? {
            guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
                return nil
            }
                            
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            guard let buffer = context.data else {
                return nil
            }

            let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
            return BufferData(context: context, buffer: pixelBuffer)
        }

        var buffers: [ProcessData: BufferData?] = [:]
        for object in data {
            switch object.mode {
            case .delete:
                buffers[object] = bind(object.image)
            case .insert:
                if let image = CGImage.generate(color: .clear, size: CGSize(width: 512, height: 512)) {
                    buffers[object] = bind(image)
                }
            }
        }
        
        guard let originalData = bind(original) else {
            return [:]
        }

        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                
                for (object, data) in buffers {
                    guard data != nil, segmenation[offset] == object.key.rawValue else { continue }
                    
                    switch object.mode {
                    case .delete:
                        data!.buffer[offset] = .clear
                    case .insert:
                        data!.buffer[offset] = originalData.buffer[offset]
                    }
                }
            }
        }
        
        var results: [FaceKey: CGImage] = [:]
        for (object, data) in buffers {
            if let cgImage = data?.context.makeImage() {
                results[object.key] = cgImage
            }
        }
        
        return results
    }
    
    /// Run the model interferense
    /// - Parameters:
    ///   - image: Image to be proceed via AI model
    ///   - data: Array of `ProcessData` which defines which parts shoul be proceed and be in output array
    ///   - completion: Function which will process recognized face parts. Gets array of pairs `FaceKey` and `CGImage` as argument.
    static func processFace(_ image: CGImage, using data: [ProcessData], _ completion: @escaping ([FaceKey: CGImage]) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let ciImage = CIImage(cgImage: image)
            
            guard let model = faceModel else {
                completion([:])
                return
            }
            
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let segmentationObservations = request.results as? [VNCoreMLFeatureValueObservation],
                      let segmentationMap = segmentationObservations.first?.featureValue.multiArrayValue,
                      let _ = segmentationMap.shape[0] as? Int, // row
                      let _ = segmentationMap.shape[1] as? Int, // column
                      let buffer = try? UnsafeBufferPointer<Int32>(segmentationMap) // MLMultiArray into Int32 Array
                else {
                    completion([:])
                    return
                }

                let segmentationArray = Array(buffer)
                            
                // Convert into readable array of separated face parts
                let results = processFaceParts(of: segmentationArray, with: image, for: data)
                completion(results)
            }
            request.imageCropAndScaleOption = .centerCrop
            
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([request])
            } catch {
                completion([:])
            }
        }
    }
}
